#include <iostream>
#include "helpers.h"

/* you can define data structures and helper functions here */


__global__ void unique_c_mask(int *d_c_c, int arr_len, bool* d_visited, bool *d_result_mask) {
        int tid = blockDim.x * blockIdx.x + threadIdx.x;
        int num_threads = blockDim.x + gridDim.x;

        for(int i = tid; i < arr_len; i += num_threads) {
            for(int j = 0; j < arr_len; ++j) {
                d_result_mask[j] = true;
                if(d_c_c[i] == d_c_c[j]) {
                    d_result_mask[j] = false;
                }

                /* 
                if(!d_visited[j]) {
                    d_visited[j] = true;
                    if(d_c_c[i] != d_c_c[j]) {
                        printf("Diff %d vs %d\n", d_c_c[i], d_c_c[j]);
                        d_result_mask[j] = true;
                    } else {
                        d_result_mask[j] = false;
                    }
                } 
                */
            }
        }
}

__global__ void createRing(int* d_cc, int cc_len, int* d_cn, int cn_len, int* d_out_ring) {
        int tid = blockDim.x * blockIdx.x + threadIdx.x;
        int num_threads = blockDim.x + gridDim.x;
        int cc_len_half = cc_len / 2;

        for(int i = tid; i < cn_len; i += num_threads) {
            for(int j = i + 1; j < cn_len; ++j) {
                for(int k = j + 1; k < cn_len; ++k) {
                    int a = d_cn[i], b = d_cn[j], c = d_cn[k];
                    int a_b_cnt = 0, b_c_cnt = 0, c_a_cnt = 0; 
                    for(int l = 0; l < cc_len; ++l) {
                        if(d_cc[l] == a || d_cc[l] == b || d_cc[l] == c) {
                            continue;
                        }

                        for(int m = l + 1; m < cc_len; ++m) {
                            if(d_cc[m] == a || d_cc[m] == b || d_cc[m] == c) {
                                continue;
                            }

                            if(d_cc[l] == d_cc[m]) {
                                if(d_cc[(l + cc_len_half) % cc_len] == a && d_cc[(m + cc_len_half) % cc_len] == b || d_cc[(l + cc_len_half) % cc_len] == b && d_cc[(m + cc_len_half) % cc_len] == a) {
                                    printf("a_b_cnt is going up by %d and %d\n", l, m);
                                    ++a_b_cnt;
                                }
 
                                if(d_cc[(l + cc_len_half) % cc_len] == b && d_cc[(m + cc_len_half) % cc_len] == c || d_cc[(l + cc_len_half) % cc_len] == c && d_cc[(m + cc_len_half) % cc_len] == b) {
                                    printf("b_c_cnt is going up by %d and %d\n", l, m);
                                    ++b_c_cnt;
                                }
                            
                                if(d_cc[(l + cc_len_half) % cc_len] == c && d_cc[(m + cc_len_half) % cc_len] == a || d_cc[(l + cc_len_half) % cc_len] == a && d_cc[(m + cc_len_half) % cc_len] == c) {
                                    printf("c_a_cnt is going up by %d and %d\n", d_cc[l], d_cc[m]);
                                    ++c_a_cnt;
                                }
                            }
                        }
                    }
                     
                    int total = a_b_cnt * b_c_cnt * c_a_cnt;
                    
                    if(total == 0) {
                        continue;
                    }

                    d_out_ring[tid] = total;   
                    //printf("a_b_cnt is %d\n", a_b_cnt); printf("b_c_cnt is %d\n", b_c_cnt); printf("c_a_cnt is %d\n", c_a_cnt);
                } 
            }
        }
}

__global__ void createRing_fin(int* d_cc, int cc_len, int* d_cn, int cn_len, int* d_out_ring) {
        int tid = blockDim.x * blockIdx.x + threadIdx.x;
        int num_threads = blockDim.x + gridDim.x;
        int cc_len_half = cc_len / 2;

        for(int i = tid; i < cn_len; i += num_threads) {
            for(int j = i + 1; j < cn_len; ++j) {
                for(int k = j + 1; k < cn_len; ++k) {
                    int a = d_cn[i], b = d_cn[j], c = d_cn[k];
                    int a_b_cnt = 0, b_c_cnt = 0, c_a_cnt = 0; 
                    for(int l = 0; l < cc_len; ++l) {
                        if(d_cc[l] == a || d_cc[l] == b || d_cc[l] == c) {
                            continue;
                        }

                        for(int m = l + 1; m < cc_len; ++m) {
                            if(d_cc[m] == a || d_cc[m] == b || d_cc[m] == c) {
                                continue;
                            }

                            if(d_cc[l] == d_cc[m]) {
                                if(d_cc[(l + cc_len_half) % cc_len] == a && d_cc[(m + cc_len_half) % cc_len] == b || d_cc[(l + cc_len_half) % cc_len] == b && d_cc[(m + cc_len_half) % cc_len] == a) {
                                    printf("a_b_cnt is going up by %d and %d\n", l, m);
                                    ++a_b_cnt;
                                }
 
                                if(d_cc[(l + cc_len_half) % cc_len] == b && d_cc[(m + cc_len_half) % cc_len] == c || d_cc[(l + cc_len_half) % cc_len] == c && d_cc[(m + cc_len_half) % cc_len] == b) {
                                    printf("b_c_cnt is going up by %d and %d\n", l, m);
                                    ++b_c_cnt;
                                }
                            
                                if(d_cc[(l + cc_len_half) % cc_len] == c && d_cc[(m + cc_len_half) % cc_len] == a || d_cc[(l + cc_len_half) % cc_len] == a && d_cc[(m + cc_len_half) % cc_len] == c) {
                                    printf("c_a_cnt is going up by %d and %d\n", d_cc[l], d_cc[m]);
                                    ++c_a_cnt;
                                }
                            }
                        }
                    }
                     
                    int total = a_b_cnt * b_c_cnt * c_a_cnt;
                    
                    if(total == 0) {
                        continue;
                    }

                    d_out_ring[tid] = total;   
                    //printf("a_b_cnt is %d\n", a_b_cnt); printf("b_c_cnt is %d\n", b_c_cnt); printf("c_a_cnt is %d\n", c_a_cnt);
                } 
            }
        }
}


/*
Input : n-o array 
Output: id of n with 2
*/
__global__ void valid_n(int* d_no, int no_len, int* d_valid_no, int* d_valid_no_len) {
    int tid = blockDim.x * blockIdx.x + threadIdx.x;
    int num_threads = blockDim.x + gridDim.x;

    int valid_no_len = 0;
    int only_c = no_len / 2, cnt = 0;
    for(int i = tid; i < no_len; i += num_threads) {
        cnt = 0; 
        for(int j = 0; j < no_len; ++j) {
            if(d_no[i] == d_no[j]) {
                ++cnt;
                printf("%d has 2 counts\n", d_no[i]);
            }
        }
        
        if(cnt == 2) {
            printf("%d has 2 counts\n", d_no[i]);
            d_valid_no[i] = d_no[i];
            ++valid_no_len; 
        }
    }
    
    d_valid_no_len[0] = valid_no_len;
}
/**
 * please remember to set final_results and final_result_size 
 * before return.
 */
void tnt_counting(int num_blocks_per_grid, int num_threads_per_block,
        int* c_c, int* c_n, int* c_h, int* n_o,
        int c_c_size, int c_n_size, int c_h_size, int n_o_size,
        int* &final_results, int &final_result_size) {
            std::cout << n_o_size << std::endl; 
            int* d_no, *d_valid_no, *d_valid_no_len;
 
            cudaMalloc((void**) &d_no, n_o_size * sizeof(int));
            cudaMalloc((void**) &d_valid_no, n_o_size * sizeof(int));
            cudaMalloc((void**) &d_valid_no_len, sizeof(int));
            
            cudaMemcpy(d_no, n_o, n_o_size * sizeof(int), cudaMemcpyHostToDevice);
            valid_n<<<num_blocks_per_grid, num_threads_per_block>>>(d_no, n_o_size, d_valid_no, d_valid_no_len); 

            int *h_valid_no = (int*) malloc(n_o_size * sizeof(int)), *h_valid_no_len = (int*) malloc(sizeof(int));
            cudaMemcpy(h_valid_no, d_valid_no, n_o_size * sizeof(int), cudaMemcpyDeviceToHost);
            cudaMemcpy(h_valid_no_len, d_valid_no_len, sizeof(int), cudaMemcpyDeviceToHost);

            std::cout << "valid_no2_len is " << h_valid_no_len[0] << std::endl;

            for(int i = 0; i < h_valid_no_len[0]; ++i)
                std::cout << h_valid_no[i] << " ";
            
            std::cout << std::endl;

            int* h_valid_c = (int*) malloc(3 * sizeof(int));
            h_valid_c[0] = 0; h_valid_c[1] = 2; h_valid_c[2] = 4;

            int* d_valid_c;
            cudaMalloc((void **) &d_valid_c, 3 * sizeof(int));
            cudaMemcpy(d_valid_c, h_valid_c, 3 * sizeof(int), cudaMemcpyHostToDevice);

            int *d_c_c;
            cudaMalloc((void**) &d_c_c, c_c_size * sizeof(int)); 
            cudaMemcpy(d_c_c, c_c, c_c_size * sizeof(int), cudaMemcpyHostToDevice);
            
            int *d_ring;
            cudaMalloc((void**) &d_ring, sizeof(int));
            int *h_ring = (int*) malloc(sizeof(int));
            createRing<<<num_blocks_per_grid, num_threads_per_block>>>(d_c_c, c_c_size, d_valid_c, 3, d_ring); 
            cudaMemcpy(h_ring, d_ring, sizeof(int), cudaMemcpyDeviceToHost);

            std::cout << h_ring[0] << std::endl;

            int *d_rings;
            cudaMalloc((void**) &d_rings, h_ring[0] * 6 * sizeof(int));

            int *h_rings = (int*) malloc(h_ring[0] * 6 * sizeof(int));
            
            createRing_fin<<<num_blocks_per_grid, num_threads_per_block>>>(d_c_c, c_c_size, d_valid_c, 3, d_rings);
            cudaMemcpy(h_rings, d_rings, h_ring[0] * 6 * sizeof(int), cudaMemcpyDeviceToHost);
            
            for(int i = 0; i < 2; ++i) {
                for(int j = 0; j < 6; ++j) {
                    std::cout << h_rings[j] << " "; 
                }
                std::cout << std::endl;
            } 
            /*// maksing unique c starting points
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
            free(h_c_visited);*/
}
