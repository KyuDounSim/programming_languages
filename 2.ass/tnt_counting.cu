#include <iostream>
#include "helpers.h"
using namespace std;
/* you can define data structures and helper functions here */


/**
 * please remember to set final_results and final_result_size 
 * before return.
 */


/*
Input: C-C array, C-C array length
Output: C-C array with c6 rings, C6ring array length
*/

__global__
void find_c6ring(int *d_out, int *d_in, int& c_c_len) {
    unsigned int d_hist_idx = blockDim.x * blockIdx.x + threadIdx.x;

    cout << d_hist_idx << endl;
    if (d_hist_idx >= numElems)
    {
        return;
    }

    unsigned int cdf_val = 0;
    for (int i = 0; i <= d_hist_idx; ++i)
    {
        cdf_val = cdf_val + d_in[i];
    }
    d_out[d_hist_idx] = cdf_val;
}

/*
Input: n-o array
Output: array of Nitrogen id's that have two Oxygen attached.

__global__ void find_no2(int *d_out, int *d_in, int numElems) {
    unsigned int d_hist_idx = blockDim.x * blockIdx.x + threadIdx.x;

    cout << d_hist_idx << endl;
    if (d_hist_idx >= numElems)
    {
        return;
    }

    unsigned int cdf_val = 0;
    for (int i = 0; i <= d_hist_idx; ++i)
    {
        cdf_val = cdf_val + d_in[i];
    }
    d_out[d_hist_idx] = cdf_val;
}
*/

void tnt_counting(int num_blocks_per_grid, int num_threads_per_block,
        int* c_c, int* c_n, int* c_h, int* n_o,
        int c_c_size, int c_n_size, int c_h_size, int n_o_size,
        int* &final_results, int &final_result_size) {

        int* d_c_c, *d_c_n, *d_c_h, *d_n_o;
        
        cudaMalloc((void **)&d_c_c, 2048 * sizeof(int));
        cudaMalloc((void **)&d_c_n, 2048 * sizeof(int));
        cudaMalloc((void **)&d_c_h, 2048 * sizeof(int));
        cudaMalloc((void **)&d_n_o, 2048 * sizeof(int));

        find_c6ring<<<num_blocks_per_grid, num_threds_per_block>>>(c_c, c_c_size);  
        
        int* c6_rings = (int*)malloc(num_blocks_per_grid * num_threds_per_block * sizeof(int));
        cudaMemcpy(c6_rings, d_c_c, numb_blocks_per_grid * num_threads_per_blck * sizeof(int), cudaMemcpyDeviceToHost);

        cudaFree(c6_rings);
        free(d_c_c);
        free(d_c_n);
        free(d_c_h);
        free(d_c_n);  
} 
