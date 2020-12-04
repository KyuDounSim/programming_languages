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
Output: array of c's id that form c6 rings

1. Yes, because in that way, we need to first check the index of 1,3,5,7 which is an inefficient jump access.

2. Given an edge (x1,x2), you can explore all edges in the edge array to find the edges that starts with x2, say(x2,x3) and (x2, x4). Then you can get two larger structure{x1,x2,x3} and {x1,x2,x4}. After you repeat this process 6 times, you would get a c6ring.

3. After thread 1 finds (x2, x3) and (x2, x4), we record the number 2, indicating that there are 2 results found be thread 1. Other threads may also record the number of results. Then we sum them together and pass this value to Host. Then Host allocate the memory based on the total number of the results. Then all GPU threads do the repeat to do the finding one more time. But this time they write the results they found to the allocated memory.
*/

__global__ void next_depth_len(int *d_in, int arr_len, bool* d_mask, int* d_out) {
        int tid = blockDim.x * blockIdx.x + threadIdx.x;
        int num_threads = blockDim.x + gridDim.x;

        int actual_c_num = arr_len / 2, cnt = 0;
        d_out[tid] = 0;
        for(int i = tid; i < actual_c_num; i += num_threads) {
            cnt = 0;
            //printf("Current elem is %d\n", d_in[i]); 
            for(int j = 0; j < arr_len; ++j) {
                if(!d_mask[i]) {
                    if(d_in[(i + actual_c_num) % arr_len] == d_in[(j + actual_c_num) % arr_len]) {
                        ++cnt;
                        //printf("As %d matches with %d and the connected edge is %d\n", d_in[i], d_in[j], d_in[(i + actual_c_num) % c_c_size]);
                        d_mask[i] = true;
                    }
                }
                
                // printf("%d matches %d times\n", d_in[i], cnt); 
            }

            printf("cnt is %d\n", cnt);
            d_out[tid] += cnt;
        }
        //printf("%d\n", cnt);
}

/*
Input: boolean mask for NO2, N-O Array, N-O Array Size 
Output: number of valid Nitrogens
*/
__global__ void valid_n_len(int *d_in, bool* d_no2_mask, int n_o_size, int& d_out) {
        int tid = blockDim.x * blockIdx.x + threadIdx.x;
        int num_threads = blockDim.x + gridDim.x;

        int cnt = 0, total = 0;
        for(int i = tid; i < n_o_size; i += num_threads) {
            cnt = 0;
            d_no2_mask[i] = true;
            for(int j = tid + 1; j < n_o_size; ++j) {
                if(!d_no2_mask[i]) { 
                    if(d_in[i] == d_in[j]) {
                        ++cnt;
                        d_no2_mask[j] = true;
                    }
                }
            }
 
            if(cnt == 1) {
                ++total; 
            }
        }
        
        d_out = total;
}


/*
Input: N-O array, N-O array length
Output: array of N's ids that have two Oxygen bonds
*/

__global__ void valid_no2(int *d_in, bool* d_no2_mask, int n_o_size, int* d_out) {
        int tid = blockDim.x * blockIdx.x + threadIdx.x;
        int num_threads = blockDim.x + gridDim.x;

        int cnt = 0;
        for(int i = tid; i < n_o_size; i += num_threads) {
            printf("tid is %d and the element is %d\n", i, d_in[i]); 
            cnt = 0;
            for(int j = tid + 1; j < n_o_size; ++j) {
                if(!d_no2_mask[i]) { 
                    if(d_in[i] == d_in[j]) {
                        ++cnt;
                        d_no2_mask[j] = true;
                    }
                }
            }
 
            if(cnt == 1) {
                d_out[tid] = d_in[i];
            }
        }  
}

void tnt_counting(int num_blocks_per_grid, int num_threads_per_block,
        int* c_c, int* c_n, int* c_h, int* n_o,
        int c_c_size, int c_n_size, int c_h_size, int n_o_size,
        int* &final_results, int &final_result_size) {

        // Find c6 rings
        int *d_c_c, *d_next_depth_len_arr;
        bool *d_mask, *h_mask = (bool*)malloc((c_c_size / 2) * sizeof(bool));

        for(int i = 0; i < c_c_size / 2; ++i) {
            h_mask[i] = false;
        }

        cudaMalloc((void **)&d_c_c, c_c_size * sizeof(int));
        cudaMalloc((void **)&d_next_depth_len_arr, (c_c_size / 2) * sizeof(int));
        cudaMalloc((void **)&d_mask, (c_c_size / 2) * sizeof(bool));         
        cudaMemcpy(d_c_c, c_c, c_c_size * sizeof(int), cudaMemcpyHostToDevice); 
        cudaMemcpy(d_mask, h_mask, (c_c_size / 2) * sizeof(bool), cudaMemcpyHostToDevice);
        
        next_depth_len<<<num_blocks_per_grid, num_threads_per_block>>>(d_c_c, c_c_size, d_mask, d_next_depth_len_arr);

        int *h_next_depth_len_arr = (int*)malloc((c_c_size / 2) * sizeof(int));

        cudaMemcpy(h_next_depth_len_arr, d_next_depth_len_arr, (c_c_size / 2) * sizeof(int), cudaMemcpyDeviceToHost);
        for(int i = 0; i < c_c_size / 2; ++i)
        {
            cout << h_next_depth_len_arr[i] << " ";
        }

        cout << endl;
 
        int next_depth_total_len = 0; 
        for(int i = 0; i < c_c_size / 2; ++i)
        {
            next_depth_total_len += h_next_depth_len_arr[i];
        }

        int *d_1st_level;
        cudaMalloc((void**) &d_1st_level, next_depth_total_len * sizeof(int));

        /*
        // Find valid Nitrogens with 2 oxygens 
        
        // First, find the number of valid n
        int *d_n_o, *d_valid_no2;
        int d_n_len;
        bool *d_no2_mask;
        cudaMalloc((void**) &d_n_len, sizeof(int));
        cudaMalloc((void **) &d_n_o, n_o_size * sizeof(int));
        cudaMalloc((void **) &d_valid_no2, n_o_size * sizeof(int));
        cudaMalloc((void **) &d_no2_mask, n_o_size * sizeof(bool)); 

        cudaMemcpy(d_n_o, n_o, n_o_size * sizeof(int), cudaMemcpyHostToDevice);
        cudaMemcpy(d_no2_mask, h_no2_mask, n_o_size * sizeof(bool), cudaMemcpyHostToDevice); 
        

        bool *h_no2_mask = (bool*)malloc(n_o_size * sizeof(bool));
        for(int i = 0; i < n_o_size; ++i) {
            h_no2_mask[i] = false;
        }
        
        int* d_n_len; int h_n_len = 0;
        cudaMalloc((void **) &d_n_len, sizeof(int)); 
        valid_n_len<<<num_blocks_per_grid, num_threads_per_block>>>(d_n_o, d_no2_mask, n_o_size, d_n_len);
        cudaMemcpy(h_n_len, d_n_len, sizeof(int), cudaMemcpyDeviceToHost);

        valid_n_len<<<num_blocks_per_grid, num_threads_per_block>>>(d_n_o, d_no2_mask, n_o_size, d_n_len);
        
        cout << h_n_len<< endl;

        // 2nd, construct the no2 array
        for(int i = 0; i < n_o_size; ++i) {
            h_no2_mask[i] = false;
        }
        
        int* h_valid_no2 = (int*)malloc(n_o_size * sizeof(int));
        cudaMemcpy(h_valid_no2, d_valid_no2, n_o_size * sizeof(int), cudaMemcpyDeviceToHost);  
        //valid_no2<<<num_blocks_per_grid, num_threads_per_block>>>(d_valid_no2, d_n_o, d_no2_mask, n_o_size);
        */
        
        // Find if alternating c is connected to a valid n 
        // Free all dynamic variables
        cudaFree(d_c_c);  
        cudaFree(d_next_depth_len_arr);
        //cudaFree(d_n_o);
        //cudaFree(d_valid_no2); 
        free(h_next_depth_len_arr);
        //free(h_valid_no2);
} 
