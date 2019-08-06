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
#include <arm_neon.h>
#include <time.h>

png_bytepp loadImageFromPNG(char* png_file_name, int * width, int * height);
int motion(png_bytepp prev, png_bytepp curr, int width, int height);

#define BLOCK_SIZE 16
#define SEARCH_BOUND 16


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

    motion(initial, current, width, height);
}

/** Will remain unoptimized.  */
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


int motion (png_bytepp prev, png_bytepp curr, int width, int height) {
    clock_t begin = clock();

    int numBlocksX = width / BLOCK_SIZE;
    int numBlocksY = height / BLOCK_SIZE;

    int  ** motionVectorR;
    int  ** motionVectorS;
    motionVectorR = calloc(numBlocksY, sizeof(int*));
    motionVectorS = calloc(numBlocksY, sizeof(int*));
    for (int i = 0; i < numBlocksY; i++) {
        motionVectorR[i] = calloc(numBlocksX, sizeof(int));
        motionVectorS[i] = calloc(numBlocksX, sizeof(int));
    }    

    uint16_t minimumSAD[numBlocksY][numBlocksX];
    memset(minimumSAD, INT_MAX, numBlocksX * numBlocksY * sizeof(uint16_t));

    register uint16_t SAD;

    int x = 0;
    int y = 0;
    /* Each block is processed in turn, by row. */
    for (int blockY = 0; blockY < numBlocksY; blockY++) {
        x = 0;
        for (int blockX = 0; blockX < numBlocksX; blockX++) {

            /* Adjust the bounds for motion vectors to account for edges */
            int sLow  = (blockY == 0) ? 0 : -SEARCH_BOUND;
            int rLow  = (blockX == 0) ? 0 : -SEARCH_BOUND;
            int sHigh = (blockY == numBlocksY - 1) ? 0 : SEARCH_BOUND;
            int rHigh = (blockX == numBlocksX - 1) ? 0 : SEARCH_BOUND;

            int r = rLow; int s = sLow;

            /* Load each row of the block into a vector */
            uint8x16_t curr0  = vld1q_u8(&(curr[y]   [x]));
            uint8x16_t curr1  = vld1q_u8(&(curr[y+1] [x]));
            uint8x16_t curr2  = vld1q_u8(&(curr[y+2] [x]));
            uint8x16_t curr3  = vld1q_u8(&(curr[y+3] [x]));
            uint8x16_t curr4  = vld1q_u8(&(curr[y+4] [x]));
            uint8x16_t curr5  = vld1q_u8(&(curr[y+5] [x]));
            uint8x16_t curr6  = vld1q_u8(&(curr[y+6] [x]));
            uint8x16_t curr7  = vld1q_u8(&(curr[y+7] [x]));
            uint8x16_t curr8  = vld1q_u8(&(curr[y+8] [x]));
            uint8x16_t curr9  = vld1q_u8(&(curr[y+9] [x]));
            uint8x16_t curr10 = vld1q_u8(&(curr[y+10][x]));
            uint8x16_t curr11 = vld1q_u8(&(curr[y+11][x]));
            uint8x16_t curr12 = vld1q_u8(&(curr[y+12][x]));
            uint8x16_t curr13 = vld1q_u8(&(curr[y+13][x]));
            uint8x16_t curr14 = vld1q_u8(&(curr[y+14][x]));
            uint8x16_t curr15 = vld1q_u8(&(curr[y+15][x]));

            /* Load each row of the block for prev frame into a vector */
            uint8x16_t prev0  = vld1q_u8(&(prev[y]   [x]));
            uint8x16_t prev1  = vld1q_u8(&(prev[y+1] [x]));
            uint8x16_t prev2  = vld1q_u8(&(prev[y+2] [x]));
            uint8x16_t prev3  = vld1q_u8(&(prev[y+3] [x]));
            uint8x16_t prev4  = vld1q_u8(&(prev[y+4] [x]));
            uint8x16_t prev5  = vld1q_u8(&(prev[y+5] [x]));
            uint8x16_t prev6  = vld1q_u8(&(prev[y+6] [x]));
            uint8x16_t prev7  = vld1q_u8(&(prev[y+7] [x]));
            uint8x16_t prev8  = vld1q_u8(&(prev[y+8] [x]));
            uint8x16_t prev9  = vld1q_u8(&(prev[y+9] [x]));
            uint8x16_t prev10 = vld1q_u8(&(prev[y+10][x]));
            uint8x16_t prev11 = vld1q_u8(&(prev[y+11][x]));
            uint8x16_t prev12 = vld1q_u8(&(prev[y+12][x]));
            uint8x16_t prev13 = vld1q_u8(&(prev[y+13][x]));
            uint8x16_t prev14 = vld1q_u8(&(prev[y+14][x]));
            uint8x16_t prev15 = vld1q_u8(&(prev[y+15][x]));
            
            /* Compute SAD for identical block position in frame */
            uint16x8_t     sum = vpaddlq_u8(vabdq_u8(curr0,  prev0));
            sum = vaddq_u16(sum, vpaddlq_u8(vabdq_u8(curr1,  prev1)));
            sum = vaddq_u16(sum, vpaddlq_u8(vabdq_u8(curr2,  prev2)));
            sum = vaddq_u16(sum, vpaddlq_u8(vabdq_u8(curr3,  prev3)));
            sum = vaddq_u16(sum, vpaddlq_u8(vabdq_u8(curr4,  prev4)));
            sum = vaddq_u16(sum, vpaddlq_u8(vabdq_u8(curr5,  prev5)));
            sum = vaddq_u16(sum, vpaddlq_u8(vabdq_u8(curr6,  prev6)));
            sum = vaddq_u16(sum, vpaddlq_u8(vabdq_u8(curr7,  prev7)));
            sum = vaddq_u16(sum, vpaddlq_u8(vabdq_u8(curr8,  prev8)));
            sum = vaddq_u16(sum, vpaddlq_u8(vabdq_u8(curr9,  prev9)));
            sum = vaddq_u16(sum, vpaddlq_u8(vabdq_u8(curr10, prev10)));
            sum = vaddq_u16(sum, vpaddlq_u8(vabdq_u8(curr11, prev11)));
            sum = vaddq_u16(sum, vpaddlq_u8(vabdq_u8(curr12, prev12)));
            sum = vaddq_u16(sum, vpaddlq_u8(vabdq_u8(curr13, prev13)));
            sum = vaddq_u16(sum, vpaddlq_u8(vabdq_u8(curr14, prev14)));
            sum = vaddq_u16(sum, vpaddlq_u8(vabdq_u8(curr15, prev15)));

            if (SAD < minimumSAD[blockY][blockX]) {
                minimumSAD[blockY][blockX] = SAD;
                motionVectorR[blockY][blockX] = 0;
                motionVectorS[blockY][blockX] = 0;
                
                /* If we have an exact match in the first block, force the next loops to never run */
                if (SAD == 0) {
                    s = SEARCH_BOUND + 1;
                    r = SEARCH_BOUND + 1;
                }
            }

            /* Loop through different motion vectors and compute the SAD for each
             * This can likely be sped up by "snaking" outwards from initial block.
             **/
            for (; s < sHigh; s++) {
                if (s == 0) continue;
                for (; r < rHigh; r++) {
                    if (r == 0) continue;

                    /* Load a shifted version of the block for computing the SAD */
                    /* FUTURE: Optimize this to not reload pixels that are used multiple times. 
                     * Change prev to an array and cycle through it. */

                    prev0  = vld1q_u8(&(prev[y+s]   [x+r]));
                    prev1  = vld1q_u8(&(prev[y+s+1] [x+r]));
                    prev2  = vld1q_u8(&(prev[y+s+2] [x+r]));
                    prev3  = vld1q_u8(&(prev[y+s+3] [x+r]));
                    prev4  = vld1q_u8(&(prev[y+s+4] [x+r]));
                    prev5  = vld1q_u8(&(prev[y+s+5] [x+r]));
                    prev6  = vld1q_u8(&(prev[y+s+6] [x+r]));
                    prev7  = vld1q_u8(&(prev[y+s+7] [x+r]));
                    prev8  = vld1q_u8(&(prev[y+s+8] [x+r]));
                    prev9  = vld1q_u8(&(prev[y+s+9] [x+r]));
                    prev10 = vld1q_u8(&(prev[y+s+10][x+r]));
                    prev11 = vld1q_u8(&(prev[y+s+11][x+r]));
                    prev12 = vld1q_u8(&(prev[y+s+12][x+r]));
                    prev13 = vld1q_u8(&(prev[y+s+13][x+r]));
                    prev14 = vld1q_u8(&(prev[y+s+14][x+r]));
                    prev15 = vld1q_u8(&(prev[y+s+15][x+r]));

                    /* Compute the Sum in 3 steps: 
                     * vapdq_u8: Compute the absdifference of elements in curr & prev. Return uint8x16_t.
                     * vpaddlq_u8: Pairwise additon to transform to u16 from u8 to prevent overflow. Return uint16x8_t.
                     * vaddq_u16: Computes the sum of all rows abs differences.
                     */

                    sum = vpaddlq_u8(vabdq_u8(curr0,  prev0));
                    sum = vaddq_u16(sum, vpaddlq_u8(vabdq_u8(curr1,  prev1)));
                    sum = vaddq_u16(sum, vpaddlq_u8(vabdq_u8(curr2,  prev2)));
                    sum = vaddq_u16(sum, vpaddlq_u8(vabdq_u8(curr3,  prev3)));
                    sum = vaddq_u16(sum, vpaddlq_u8(vabdq_u8(curr4,  prev4)));
                    sum = vaddq_u16(sum, vpaddlq_u8(vabdq_u8(curr5,  prev5)));
                    sum = vaddq_u16(sum, vpaddlq_u8(vabdq_u8(curr6,  prev6)));
                    sum = vaddq_u16(sum, vpaddlq_u8(vabdq_u8(curr7,  prev7)));
                    sum = vaddq_u16(sum, vpaddlq_u8(vabdq_u8(curr8,  prev8)));
                    sum = vaddq_u16(sum, vpaddlq_u8(vabdq_u8(curr9,  prev9)));
                    sum = vaddq_u16(sum, vpaddlq_u8(vabdq_u8(curr10, prev10)));
                    sum = vaddq_u16(sum, vpaddlq_u8(vabdq_u8(curr11, prev11)));
                    sum = vaddq_u16(sum, vpaddlq_u8(vabdq_u8(curr12, prev12)));
                    sum = vaddq_u16(sum, vpaddlq_u8(vabdq_u8(curr13, prev13)));
                    sum = vaddq_u16(sum, vpaddlq_u8(vabdq_u8(curr14, prev14)));
                    sum = vaddq_u16(sum, vpaddlq_u8(vabdq_u8(curr15, prev15)));

                    // uint16x8_t     sum0 = vpaddlq_u8(vabdq_u8(curr0, &(prev[y][x])));
                    // uint16x8_t     sum1 = vpaddlq_u8(vabdq_u8(curr1, &(prev[y+1][x])));
                    // uint16x8_t     sum2 = vpaddlq_u8(vabdq_u8(curr2, &(prev[y+2][x])));
                    // uint16x8_t     sum3 = vpaddlq_u8(vabdq_u8(curr3, &(prev[y+3][x])));

                    // sum0 = vaddq_u16(sum0, vpaddlq_u8(vabdq_u8(curr4,  &(prev[y+4][x]))));
                    // sum1 = vaddq_u16(sum1, vpaddlq_u8(vabdq_u8(curr5,  &(prev[y+5][x]))));
                    // sum2 = vaddq_u16(sum2, vpaddlq_u8(vabdq_u8(curr6,  &(prev[y+6][x]))));
                    // sum3 = vaddq_u16(sum3, vpaddlq_u8(vabdq_u8(curr7,  &(prev[y+7][x]))));

                    // sum0 = vaddq_u16(sum0, vpaddlq_u8(vabdq_u8(curr8,  &(prev[y+8][x]))));
                    // sum1 = vaddq_u16(sum1, vpaddlq_u8(vabdq_u8(curr9,  &(prev[y+9][x]))));
                    // sum2 = vaddq_u16(sum2, vpaddlq_u8(vabdq_u8(curr10, &(prev[y+10][x]))));
                    // sum3 = vaddq_u16(sum3, vpaddlq_u8(vabdq_u8(curr11, &(prev[y+11][x]))));

                    // sum0 = vaddq_u16(sum0, vpaddlq_u8(vabdq_u8(curr12, &(prev[y+12][x]))));
                    // sum1 = vaddq_u16(sum1, vpaddlq_u8(vabdq_u8(curr13, &(prev[y+13][x]))));
                    // sum2 = vaddq_u16(sum2, vpaddlq_u8(vabdq_u8(curr14, &(prev[y+14][x]))));
                    // sum3 = vaddq_u16(sum3, vpaddlq_u8(vabdq_u8(curr15, &(prev[y+15][x]))));

                    /* Sum the resultant vector elements */
                    SAD = vgetq_lane_u16(sum, 0);
                    SAD = vgetq_lane_u16(sum, 1);
                    SAD = vgetq_lane_u16(sum, 2);
                    SAD = vgetq_lane_u16(sum, 3);
                    SAD = vgetq_lane_u16(sum, 4);
                    SAD = vgetq_lane_u16(sum, 5);
                    SAD = vgetq_lane_u16(sum, 6);
                    SAD = vgetq_lane_u16(sum, 7);

                    if (SAD < minimumSAD[blockY][blockX]) {
                        minimumSAD[blockY][blockX] = SAD;
                        motionVectorR[blockY][blockX] = r;
                        motionVectorS[blockY][blockX] = s;
                        
                        /* If we have an exact match, we are done this block. */
                        if (SAD == 0) {
                            s = SEARCH_BOUND + 1;
                            r = SEARCH_BOUND + 1;
                        }
                    }
                }
            }
            x += BLOCK_SIZE;
        }
        y += BLOCK_SIZE;
    }

    double ttc = (double)(clock() - begin) / CLOCKS_PER_SEC;

    
    /* Strictly for printing SAD output. */
    for (int j = 0; j < numBlocksY; j++) {
        for (int i = 0; i < numBlocksX; i++) {
            printf("BLOCK %d @ [%02d, %02d]: SAD %d with motion (% 02d, % 02d)\n", j*numBlocksY + i, i, j, minimumSAD[j][i], motionVectorR[j][i],motionVectorS[j][i]);
        }
    }

    printf("Completed in %f.\n", ttc);
}