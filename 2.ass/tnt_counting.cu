#include <iostream>
#include "helpers.h"
using namespace std;
/* you can define data structures and helper functions here */


/**
 * please remember to set final_results and final_result_size 
 * before return.
 */




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


/*
Input: C-C array, C-C array length
Output: array of c's id that form c6 rings

1. Yes, because in that way, we need to first check the index of 1,3,5,7 which is an inefficient jump access.
2. Given an edge (x1,x2), you can explore all edges in the edge array to find the edges that starts with x2, say(x2,x3) and (x2, x4). Then you can get two larger structure{x1,x2,x3} and {x1,x2,x4}. After you repeat this process 6 times, you would get a c6ring.
*/

__global__ void find_c6ring(int *d_out, int *d_in, int c_c_size) {
        int tid = blockDim.x * blockIdx.x + threadIdx.x;
        int num_threads = blockDim.x + gridDim.x;

        int actual_c_num = c_c_size / 2;
        int cnt = 0;
        

        for(int i = tid; i < c_c_size; i += num_threads) {
            cnt = 0; 
            printf("Current elem is %d\n", d_in[i]); 
            for(int j = 0; j < c_c_size; ++j) {
                if(d_in[(i + actual_c_num) % c_c_size] == d_in[j]) {
                    ++cnt;
                    printf("As %d matches with %d and the connected edge is %d\n", d_in[i], d_in[j], d_in[(i + actual_c_num) % c_c_size]);
                }
            }
            printf("%d matches %d times\n", d_in[i], cnt); 
        }
        //printf("%d\n", cnt);
}


/*
Input: N-O array, N-O array length
Output: array of N's ids that have two Oxygen bonds
*/
__global__ void valid_no2(int *d_out, int *d_int, int n_o_size) {
        int tid = blockDim.x * blockIdx.x + threadIdx.x;
        int num_threads = blockDim.x + gridDim.x;

        for(int i = tid ; i < n_o_size; i += num_threads) {
             
        }  
}

void tnt_counting(int num_blocks_per_grid, int num_threads_per_block,
        int* c_c, int* c_n, int* c_h, int* n_o,
        int c_c_size, int c_n_size, int c_h_size, int n_o_size,
        int* &final_results, int &final_result_size) {

        //int total_elem_num = num_blocks_per_grid * num_threads_per_block;
        cout << c_c_size << endl;

        int *d_c_c, *d_c6_rings;
 
        /*
        for(int i = 0; i < c_n_size; ++i) {
            cout << c_n[i] << " ";
        }

        cout << endl;
        cout << c_n_size << endl;
        */
        //int *d_c_c_size; 
        //*d_c_n, *d_c_h, *d_n_o;
        cudaMalloc((void **)&d_c_c, c_c_size * sizeof(int));
        cudaMalloc((void **)&d_c6_rings, c_c_size * sizeof(int)); 
        //cudaMalloc((void **)&d_c_c_size, sizeof(int));
        //cout << c_c_size << endl; 
        cudaMemcpy(d_c_c, c_c, c_c_size * sizeof(int), cudaMemcpyHostToDevice);
        //cudaMemcpy(d_c_c_size, c_c_size, sizeof(int), cudaMemcpyHostToDevice);
        find_c6ring<<<num_blocks_per_grid, num_threads_per_block>>>(d_c6_rings, d_c_c, c_c_size);

        int *h_c6_rings = (int*)malloc(c_c_size * sizeof(int));
        cudaMemcpy(h_c6_rings, d_c6_rings, c_c_size * sizeof(int), cudaMemcpyDeviceToHost);

        int *d_n_o, *d_valid_no2;

        cudaMalloc((void **) &d_n_o, n_o_size * sizeof(int));
        cudaMalloc((void **) &d_valid_no2, n_o_size * sizeof(int));
        //cudaMemcpy(d_n_o, n_o, n_o_size * sizeof(int), cudaMemcpyHostToDevice);
        //valid_no2<<<num_blocks_per_grid, num_threads_per_block>>>(d_valid_no2, d_n_o, n_o_size * sizeof(int), cudaMemcpyHostToDevice);

        //int* h_valid_no2 = (int*)malloc(n_o_size * sizeof(int));
        //cudaMemcpy(h_valid_no2, d_valid_no2, n_o_size * sizeof(int), cudaMemcpyHostToDevice);  

        cudaFree(d_c_c);  
        cudaFree(d_c6_rings);
        cudaFree(d_n_o);
        //cudaFree(d_valid_no2); 
        free(h_c6_rings);
        //free(h_valid_no2);
} 
