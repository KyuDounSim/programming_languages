#include <iostream>
#include "helpers.h"

/* you can define data structures and helper functions here */


/*
__global__ void unique_c_mask(int *d_c_c, int arr_len, bool* d_visited, bool *d_result_mask) {
        int tid = blockDim.x * blockIdx.x + threadIdx.x;
        int num_threads = blockDim.x + gridDim.x;

        for(int i = tid; i < arr_len; i += num_threads) {
            for(int j = tid + 1; j < arr_len; ++j) {
                if(!d_visited[j]) {
                    d_visited[j] = true;
                    if(d_c_c[i] != d_c_c[j]) {
                        printf("Diff %d vs %d\n", d_c_c[i], d_c_c[j]);
                        d_result_mask[j] = true;
                    } else {
                        d_result_mask[j] = false;
                    }
                } 
            }
        }
}
*/


/**
 * please remember to set final_results and final_result_size 
 * before return.
 */
void tnt_counting(int num_blocks_per_grid, int num_threads_per_block,
        int* c_c, int* c_n, int* c_h, int* n_o,
        int c_c_size, int c_n_size, int c_h_size, int n_o_size,
        int* &final_results, int &final_result_size) {

            /* // maksing unique c starting points
            int * d_c_c; 
            cudaMalloc((void **) &d_c_c, c_c_size * sizeof(int)); 
            
            bool *h_unique_c_mask, *h_c_visited;
            h_unique_c_mask = (bool*) malloc((c_c_size / 2) * sizeof(bool));
            h_c_visited = (bool*) malloc((c_c_size / 2) * sizeof(bool));
            
            for(int i = 0; i < c_c_size / 2; ++i) {
                h_c_visited[i] = false;
            }

            bool* d_unique_c_mask, *d_c_visited; 
            cudaMalloc((void **) &d_unique_c_mask, c_c_size / 2 * sizeof(bool));
            cudaMalloc((void **) &d_c_visited, c_c_size / 2 * sizeof(bool));

            cudaMemcpy(d_c_c, c_c, c_c_size * sizeof(int), cudaMemcpyHostToDevice);
            cudaMemcpy(d_unique_c_mask, h_unique_c_mask, (c_c_size / 2 ) * sizeof(bool), cudaMemcpyHostToDevice);
            cudaMemcpy(d_c_visited, h_c_visited, (c_c_size / 2 ) * sizeof(bool), cudaMemcpyHostToDevice);

            unique_c_mask<<<num_blocks_per_grid, num_threads_per_block>>>(d_c_c, c_c_size / 2, d_c_visited, d_unique_c_mask); 
            cudaMemcpy(h_unique_c_mask, d_unique_c_mask, (c_c_size / 2) * sizeof(bool), cudaMemcpyDeviceToHost);

            for(int i = 0; i < c_c_size / 2; ++i) {
                std::cout << h_unique_c_mask[i] << std::endl; 
            }
            
            cudaFree(d_c_c);
            cudaFree(d_unique_c_mask);
            cudaFree(d_c_visited);
            free(h_unique_c_mask);
            free(h_c_visited); */
            
}
