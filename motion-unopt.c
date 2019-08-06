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
int motion(png_bytepp prev, png_bytepp curr, int width, int height);
void testImageRead(png_bytepp image, int height, int width);

#define BLOCK_SIZE 16
#define SEARCH_AREA 16


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
    
    // if (height != cheight || width != cwidth) fatal_error("ERROR: Expect equal sized frames as input.");

    motion(initial, current, width, height);
    // testImageRead(initial, height, width);
    // testImageRead(current, height, width);
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
    *height = png_get_image_height(png_ptr, info_ptr);
    png_bytepp image = (png_bytepp)malloc(sizeof(png_bytep) * *height);
    for (int i = 0; i < *width; i++) image[i] = (png_bytep)malloc(png_get_rowbytes(png_ptr, info_ptr));

    /* Preform the actual read of the PNG image */
    png_read_image(png_ptr, image);

    /* Cleanup */
    png_destroy_read_struct(&png_ptr, &info_ptr, NULL);

    return image;
}

int motion(png_bytepp prev, png_bytepp curr, int width, int height) {

    const int numBlocksX = width / BLOCK_SIZE;
    const int numBlocksY = height / BLOCK_SIZE;

    register int diff;
    register int SAD;
    register int r;
    register int s;

    // int **SADResults = calloc(BLOCK_SIZE, sizeof(int) * BLOCK_SIZE);
    // int ***MVECResults = calloc(BLOCK_SIZE*2, sizeof(int) * BLOCK_SIZE*2);

    int SADResults[numBlocksY][numBlocksX];
    int MVECResults[numBlocksY][numBlocksX][2];
    memset(SADResults, 0, numBlocksX * numBlocksY * sizeof(int));
    memset(MVECResults, 0, numBlocksX * numBlocksY * 2 * sizeof(int));
    
    
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
    // int pixel_displacement[8][2] = {
    //     {-16, -16}, {0, -16},  {16, -16},
    //     {-16, 0},  /* 0, 0 */ {16, 0},
    //     {-16, 16},  {0, 16},  {16, 16}
    // };

    int x = 0;
    int y = 0;
    for (int yBlock = 0; yBlock < numBlocksY; yBlock++) {
        x = 0;
        for (int xBlock = 0; xBlock < numBlocksX; xBlock++) {
            /* NEED TO ACCOUNT FOR EDGE BLOCKS!!!! */
            /* Specifically, blocks in y 0 or BLOCK_SIZE, or x 0 or BLOCK_SIZE need special cases */
            /* But for all internal blocks, no special handling is needed. */
            // printf("\n=== Block (%d:%d, %d:%d):\n", xBlock, x, yBlock, y);
            
            int minSAD = INT_MAX;
            int min_mX = 0;
            int min_mY = 0;

            for (int s = -SEARCH_AREA; s < SEARCH_AREA; s += 1) {
                for (int r = -SEARCH_AREA; r < SEARCH_AREA; r += 1) {
                    /* Skip comparisons if we are checking the same pixels, or outside the image */
                    if (r == 0 && s == 0) continue;
                    if (y + s < 0) continue;
                    if (y + s + BLOCK_SIZE > height) continue;
                    if (x + r < 0) continue;
                    if (x + r + BLOCK_SIZE > height) continue;

        

                    int SAD = 0;
                    for (int j = 0; j < BLOCK_SIZE; j++) {
                        for (int i = 0; i < BLOCK_SIZE; i++) {
                            /* Compute the difference of equivelant pixels */
                            diff = curr[y + j][x + i] - prev[y + j + s][x + i + r];
                            if (diff < 0) SAD -= diff;
                            else SAD += diff;
                        }
                    }
                    // printf("\tComputing sad at (x+r: %d, y+s: %d): %d \n\t\t", x+r, y+s, SAD);
                    
                    if (SAD < minSAD) {
                        minSAD = SAD;
                        min_mX = r;
                        min_mY = s;
                        // printf("\n\t\t!!!!New minSAD: %d at (%d,%d)\n", minSAD, r, s);
                        // printf("Found new min SAD for block [%02d,%02d]: (%02d, %02d) = %d \n",xBlock, yBlock, r, s, SAD);

                    }

                }
            }

            SADResults[yBlock][xBlock] = minSAD;
            MVECResults[yBlock][xBlock][0] = min_mX;
            MVECResults[yBlock][xBlock][1] = min_mY;

            x += BLOCK_SIZE;
        }

        y += BLOCK_SIZE;
    }

    for (int j = 0; j < numBlocksY; j++) {
        for (int i = 0; i < numBlocksX; i++) {
            printf("%d, %d | %d | %d | %d\n", i, j, SADResults[j][i], MVECResults[j][i][0],MVECResults[j][i][1]);
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