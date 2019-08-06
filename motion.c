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
void sumAbsoluteDifferences(uint16_t * SAD, uint8x16_t * curr, uint8x16_t * prev, int offset);

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

    uint16_t SAD;

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

            uint8x16_t  *currRows;
            curr = malloc(BLOCK_SIZE * sizeof(uint8x16_t));
            uint8x16_t  *prevRows;
            curr = malloc(BLOCK_SIZE * sizeof(uint8x16_t));

            int offset = 0;

            /* Load each row of the block into a vector */
            currRows[0]   = vld1q_u8(&(curr[y]   [x]));
            currRows[1]   = vld1q_u8(&(curr[y+1] [x]));
            currRows[2]   = vld1q_u8(&(curr[y+2] [x]));
            currRows[3]   = vld1q_u8(&(curr[y+3] [x]));
            currRows[4]   = vld1q_u8(&(curr[y+4] [x]));
            currRows[5]   = vld1q_u8(&(curr[y+5] [x]));
            currRows[6]   = vld1q_u8(&(curr[y+6] [x]));
            currRows[7]   = vld1q_u8(&(curr[y+7] [x]));
            currRows[8]   = vld1q_u8(&(curr[y+8] [x]));
            currRows[9]   = vld1q_u8(&(curr[y+9] [x]));
            currRows[10]  = vld1q_u8(&(curr[y+10][x]));
            currRows[11]  = vld1q_u8(&(curr[y+11][x]));
            currRows[12]  = vld1q_u8(&(curr[y+12][x]));
            currRows[13]  = vld1q_u8(&(curr[y+13][x]));
            currRows[14]  = vld1q_u8(&(curr[y+14][x]));
            currRows[15]  = vld1q_u8(&(curr[y+15][x]));

            /* Load each row of the block for prev frame into a vector */
            prevRows[0]   = vld1q_u8(&(prev[y]   [x]));
            prevRows[1]   = vld1q_u8(&(prev[y+1] [x]));
            prevRows[2]   = vld1q_u8(&(prev[y+2] [x]));
            prevRows[3]   = vld1q_u8(&(prev[y+3] [x]));
            prevRows[4]   = vld1q_u8(&(prev[y+4] [x]));
            prevRows[5]   = vld1q_u8(&(prev[y+5] [x]));
            prevRows[6]   = vld1q_u8(&(prev[y+6] [x]));
            prevRows[7]   = vld1q_u8(&(prev[y+7] [x]));
            prevRows[8]   = vld1q_u8(&(prev[y+8] [x]));
            prevRows[9]   = vld1q_u8(&(prev[y+9] [x]));
            prevRows[10]  = vld1q_u8(&(prev[y+10][x]));
            prevRows[11]  = vld1q_u8(&(prev[y+11][x]));
            prevRows[12]  = vld1q_u8(&(prev[y+12][x]));
            prevRows[13]  = vld1q_u8(&(prev[y+13][x]));
            prevRows[14]  = vld1q_u8(&(prev[y+14][x]));
            prevRows[15]  = vld1q_u8(&(prev[y+15][x]));
            
            /* Compute SAD for identical block position in frame */

            sumAbsoluteDifferences(&SAD, currRows, prevRows, offset);

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
            for (;r < rHigh;r++) {
                if (r == 0) continue;
                    /* Load a shifted version of the block for computing the SAD
                     *
                     * if we progress row by row for a given r value (read: static x pos), we only 
                     * need to read each subsequent row for the SAD operation, replacing the top-most vectors
                     * 
                     * Initially load the top of the s chain.
                     **/
                    offset = 0;
                    prevRows[0]   = vld1q_u8(&(prev[y+s]   [x+r]));
                    prevRows[1]   = vld1q_u8(&(prev[y+s+1] [x+r]));
                    prevRows[2]   = vld1q_u8(&(prev[y+s+2] [x+r]));
                    prevRows[3]   = vld1q_u8(&(prev[y+s+3] [x+r]));
                    prevRows[4]   = vld1q_u8(&(prev[y+s+4] [x+r]));
                    prevRows[5]   = vld1q_u8(&(prev[y+s+5] [x+r]));
                    prevRows[6]   = vld1q_u8(&(prev[y+s+6] [x+r]));
                    prevRows[7]   = vld1q_u8(&(prev[y+s+7] [x+r]));
                    prevRows[8]   = vld1q_u8(&(prev[y+s+8] [x+r]));
                    prevRows[9]   = vld1q_u8(&(prev[y+s+9] [x+r]));
                    prevRows[10]  = vld1q_u8(&(prev[y+s+10][x+r]));
                    prevRows[11]  = vld1q_u8(&(prev[y+s+11][x+r]));
                    prevRows[12]  = vld1q_u8(&(prev[y+s+12][x+r]));
                    prevRows[13]  = vld1q_u8(&(prev[y+s+13][x+r]));
                    prevRows[14]  = vld1q_u8(&(prev[y+s+14][x+r]));
                    prevRows[15]  = vld1q_u8(&(prev[y+s+15][x+r]));

                for (;s < sHigh - 1;s++) {
                    if (s == 0) continue;
                    sumAbsoluteDifferences(&SAD, currRows, prevRows, offset);
                    
                    /* Load the next row for shift s */
                    prevRows[++offset] = vld1q_u8(&(prev[y+s+15][x+r]));

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

void sumAbsoluteDifferences(uint16_t * SAD, uint8x16_t * curr, uint8x16_t * prev, int offset) {
       /* Compute the Sum in 3 steps: 
        * vapdq_u8: Compute the absdifference of elements in curr & prev. Return uint8x16_t.
        * vpaddlq_u8: Pairwise additon to transform to u16 from u8 to prevent overflow. Return uint16x8_t.
        * vaddq_u16: Computes the sum of all rows abs differences.
        */

        /* Compute SAD for identical block position in frame */
        uint16x8_t     sum = vpaddlq_u8(vabdq_u8(curr[0],  prev[0+offset]));
        sum = vaddq_u16(sum, vpaddlq_u8(vabdq_u8(curr[1],  prev[1+offset])));
        sum = vaddq_u16(sum, vpaddlq_u8(vabdq_u8(curr[2],  prev[2+offset])));
        sum = vaddq_u16(sum, vpaddlq_u8(vabdq_u8(curr[3],  prev[3+offset])));
        sum = vaddq_u16(sum, vpaddlq_u8(vabdq_u8(curr[4],  prev[4+offset])));
        sum = vaddq_u16(sum, vpaddlq_u8(vabdq_u8(curr[5],  prev[5+offset])));
        sum = vaddq_u16(sum, vpaddlq_u8(vabdq_u8(curr[6],  prev[6+offset])));
        sum = vaddq_u16(sum, vpaddlq_u8(vabdq_u8(curr[7],  prev[7+offset])));
        sum = vaddq_u16(sum, vpaddlq_u8(vabdq_u8(curr[8],  prev[8+offset])));
        sum = vaddq_u16(sum, vpaddlq_u8(vabdq_u8(curr[9],  prev[9+offset])));
        sum = vaddq_u16(sum, vpaddlq_u8(vabdq_u8(curr[10], prev[10+offset])));
        sum = vaddq_u16(sum, vpaddlq_u8(vabdq_u8(curr[11], prev[11+offset])));
        sum = vaddq_u16(sum, vpaddlq_u8(vabdq_u8(curr[12], prev[12+offset])));
        sum = vaddq_u16(sum, vpaddlq_u8(vabdq_u8(curr[13], prev[13+offset])));
        sum = vaddq_u16(sum, vpaddlq_u8(vabdq_u8(curr[14], prev[14+offset])));
        sum = vaddq_u16(sum, vpaddlq_u8(vabdq_u8(curr[15], prev[15+offset])));

        /* Sum the resultant vector elements */
        *SAD  = vgetq_lane_u16(sum, 0);
        *SAD += vgetq_lane_u16(sum, 1);
        *SAD += vgetq_lane_u16(sum, 2);
        *SAD += vgetq_lane_u16(sum, 3);
        *SAD += vgetq_lane_u16(sum, 4);
        *SAD += vgetq_lane_u16(sum, 5);
        *SAD += vgetq_lane_u16(sum, 6);
        *SAD += vgetq_lane_u16(sum, 7);

}