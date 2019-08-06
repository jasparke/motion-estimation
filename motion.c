/*
 * Motion Estimation - Unoptimized
 * 
 * SENG 440 - Summer 2019
 * Jason Parker - V00857251
 */

#include <png.h>
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>
#include <stdarg.h>

png_bytepp loadImageFromPNG(char* png_file_name, int * width, int * height);
int motion(png_bytepp prev, png_bytepp curr, int height, int width);
void testImageRead(png_bytepp image, int height, int width);

#define BLOCK_SIZE 16


static void fatal_error (const char * message, ...) {
    va_list args;
    va_start (args, message);
    vfprintf(stderr, message, args);
    va_end (args);
    exit(EXIT_FAILURE);
}

int main (int argc, char **argv) {
    if (argc < 2) fatal_error("Usage: ./motion FIRST_FRAME.PNG SECOND_FRAME.PNG");
    
    int height, width, cheight, cwidth;
    png_bytep * initial = loadImageFromPNG(argv[1], &width, &height);
    png_bytep * current = loadImageFromPNG(argv[2], &cwidth, &cheight);
    
    if (height != cheight || width != cwidth) fatal_error("ERROR: Expect equal sized frames as input.");

    // motion(&prev, &curr, height, width);
}

png_bytepp loadImageFromPNG(char *png_file_name, int * width, int * height) {
    FILE *imageFile = fopen(png_file_name, "rb");
    if (!imageFile) fatal_error("ERROR: Unable to open file %s.", png_file_name);

    png_structp png_ptr = png_create_read_struct(PNG_LIBPNG_VER_STRING, NULL, NULL, NULL);
    if (! png_ptr ) fatal_error("ERROR: Unable to open PNG: %s", png_file_name);

    png_infop info_ptr = png_create_info_struct(png_ptr);
    png_init_io(png_ptr, imageFile);
    png_read_info(png_ptr, info_ptr);

    /* Store the width/height of the PNG, then initialize a png_byte array for the
     * bytes of the image. Not sure if you actually need the for loop here, should
     * check later. Not optimizing as not relevant.
     **/
    *width = png_get_image_width(png_ptr, info_ptr);
    *height = png_get_image_width(png_ptr, info_ptr);
    png_bytepp image = (png_bytepp)malloc(sizeof(png_bytep) * *height);
    for (int i = 0; i < *width; i++) image[i] = (png_bytep)malloc(png_get_rowbytes(png_ptr, info_ptr));

    /* Preform the actual read of the PNG image */
    png_read_image(png_ptr, image);

    /* Cleanup */
    png_destroy_read_struct(&png_ptr, &info_ptr, NULL);

    return image;
}

int motion(png_bytepp prev, png_bytepp curr, int height, int width) {

    const int numBlocksX = width / BLOCK_SIZE;
    const int numBlocksY = height / BLOCK_SIZE;

    register int diff;
    register int SAD;
    register int r;
    register int s;

    int **SADResults = calloc(BLOCK_SIZE, sizeof(int) * BLOCK_SIZE);
    
    /*
     * Check the 8 surrounding blocks of the image to determine which block matches best.
     * For example, for block X, all # blocks would be checked:
     *  0 1 2 3 4 5
     *  * * * * * * 0
     *  * # # # * * 1
     *  * # X # * * 2
     *  * # # # * * 3
     *  * * * * * * 4
     *  * * * * * * 5
     */

    // const int block_displacement[8][2] = {
    //     {-1, -1}, {0, -1}, {1, -1},
    //     {-1, 0}, /* 0, 0 */ {1, 0},
    //     {-1, 1},   {0, 1},  {1, 1}
    // };
    int pixel_displacement[8][2] = {
        {-16, -16}, {0, -16},  {16, -16},
        {-16, 0},  /* 0, 0 */ {16, 0},
        {-16, 16},  {0, 16},  {16, 16}
    };

    /* Loop over each block in the image, and  */
    for (int row = 0; row < height; row += BLOCK_SIZE) {
        for (int col = 0; col < width; col += BLOCK_SIZE) {
            /* NEED TO ACCOUNT FOR EDGE BLOCKS!!!! */
            /* Specifically, blocks in row 0 or BLOCK_SIZE, or col 0 or BLOCK_SIZE need special cases */
            /* But for all internal blocks, no special handling is needed. */

            
            int minSAD = INT_MAX;
            int *mVec = { 0 };

            for (int b = 0; b < 8; b++) {
                r = pixel_displacement[b][0];
                s = pixel_displacement[b][1];

                int SAD = 0;
                /* Can only check blocks that are still part of the image. Skip edges. */
                if (row == 0 && (b < 3)) {
                    SAD = INT_MAX;
                    continue;
                };
                if (height - row < BLOCK_SIZE && b > 4) {
                    SAD = INT_MAX;
                    continue;
                };
                if (col == 0 && (b == 0 || b == 3 || b == 5)) {
                    SAD = INT_MAX;
                    continue;
                };
                if (width - col < BLOCK_SIZE && (b == 2 || b == 4 || b == 7)) {
                    SAD = INT_MAX;
                    continue;
                };

                /* r + s are predefined, this could be unrolled a lot. */
                for (int y; y < BLOCK_SIZE; y++) {
                    for (int x; x < BLOCK_SIZE; x++) {
                        /* Compute the difference of equivelant pixels */
                        diff = curr[row + y][col + x] - prev[row + y + s][col + x + r];
                        if (diff < 0) SAD -= diff;
                        else SAD += diff;
                    }
                }

                if (SAD < minSAD) {
                    minSAD = SAD;
                    mVec = pixel_displacement[b];
                }
            }
        }
    }


    return 1;
}

/* Reads and prints a very very basic greyscale representation of the image. */
void testImageRead(png_bytepp image, int height, int width) {
    printf("Read image as %dx%d.\n", width, height);
    for (int y = 0; y < height; y++) {
        for (int x = 0; x < width; x++) {
            if (image[y][x] < 155) printf("-");
            else printf("#");
        }
        printf("\n");
    }
}

// void print_uint8 (uint8x16_t data, char* name) {
//     // http://www.armadeus.org/wiki/index.php?title=NEON_HelloWorld
// }