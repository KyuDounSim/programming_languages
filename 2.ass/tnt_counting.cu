#include <iostream>
#include <setjmp.h>
#include "helpers.h"

/* you can define data structures and helper functions here */

__global__ void valid_n_counter(int* cn, int cn_len, int* no, int no_len, bool* valid_n_num)  {
    int tid = blockDim.x * blockIdx.x + threadIdx.x;
    int num_threads = blockDim.x * gridDim.x;

    for(int i = tid; i < cn_len ; i += num_threads) {
        int n_ctr = 0;
        
        for(int j = 0; j < no_len; ++j) {
            if(cn[i + cn_len] == no[j]) {
                ++n_ctr;
            }
        }

        if(n_ctr == 2) {
            //printf("tid is %d", tid);
            valid_n_num[tid] = true;
        }
    }
}

__global__ void combination_generator(int * cn, bool* mask, int cn_len, int* d_out) {
    int tid = blockDim.x * blockIdx.x + threadIdx.x;
    int num_threads = blockDim.x + gridDim.x;

    int total_num = 0;

    for(int i = tid; i < cn_len; i += num_threads) {
        for(int j = i + 1; j < cn_len; ++j) {
            for(int k = j + 1; k < cn_len; ++k) {
                if(mask[i] == true && mask[j] == true && mask[k] == true) {
                    //printf("%d and %d and %d\n", cn[i], cn[j], cn[k]);
                    d_out[total_num * 3 + 0] = cn[i];
                    d_out[total_num * 3 + 1] = cn[j];
                    d_out[total_num * 3 + 2] = cn[k];
                    ++total_num;
                }
            }
        }
    }
}

__global__ void find_connectors(int* d_cc, int cc_len, int* d_cn, int cn_len, int* d_out_ring) {
        int tid = blockDim.x * blockIdx.x + threadIdx.x;
        int num_threads = blockDim.x * gridDim.x;
        int cc_len_half = cc_len / 2;
        int ring_cnt = 0;

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
                                    //printf("a_b_cnt is going up by %d and %d\n", l, m);
                                    ++a_b_cnt;
                                }
 
                                if(d_cc[(l + cc_len_half) % cc_len] == b && d_cc[(m + cc_len_half) % cc_len] == c || d_cc[(l + cc_len_half) % cc_len] == c && d_cc[(m + cc_len_half) % cc_len] == b) {
                                    //printf("b_c_cnt is going up by %d and %d\n", l, m);
                                    ++b_c_cnt;
                                }
                            
                                if(d_cc[(l + cc_len_half) % cc_len] == c && d_cc[(m + cc_len_half) % cc_len] == a || d_cc[(l + cc_len_half) % cc_len] == a && d_cc[(m + cc_len_half) % cc_len] == c) {
                                    //printf("c_a_cnt is going up by %d and %d\n", d_cc[l], d_cc[m]);
                                    ++c_a_cnt;
                                }
                            }
                        }
                    }
                     
                    int total = a_b_cnt * b_c_cnt * c_a_cnt;
                    
                    if(total == 0) {
                        continue;
                    }

                    d_out_ring[ring_cnt * 3 + 0] = a_b_cnt;
                    d_out_ring[ring_cnt * 3 + 1] = b_c_cnt;
                    d_out_ring[ring_cnt * 3 + 2] = c_a_cnt;
                    ++ring_cnt;
                    //d_out_ring[tid] = total;   
                    //printf("a_b_cnt is %d\n", a_b_cnt); printf("b_c_cnt is %d\n", b_c_cnt); printf("c_a_cnt is %d\n", c_a_cnt);
                } 
            }
        }
}

//__global__ void createRing(int* d_cc, int cc_len, int* d_c_tuple, int tuple_len, int* d_connector_num, int d_connector_num_size, int total_ring_num, int* d_out_ring) {
__global__ void createRing(int* d_cc, int cc_len, int* d_c_tuple, int tuple_len, int* d_connector_num, int total_ring_num, int* d_out_ring) {
    int tid = blockDim.x * blockIdx.x + threadIdx.x;
    //int num_threads = blockDim.x * gridDim.x;

    int cc_len_half = cc_len / 2;

    int a = 0, b = 0, c = 0, a_b_cnt = 0, b_c_cnt = 0, c_a_cnt = 0;

    // tuple_len == 1
    for(int i = 0; i < tuple_len; i += 3) {
    //for(int i = tid; i < tuple_len; i += (3 * num_threads)) {
        //printf("what is i or tid? It is %d\n", i);
        a = d_c_tuple[i * 3 + 0]; b = d_c_tuple[i * 3 + 1]; c = d_c_tuple[i * 3 + 2];
        //printf("a, b, c is each %d, %d, %d\n", a, b, c);

        a_b_cnt = 0;
        b_c_cnt = 0;
        c_a_cnt = 0;
        
        for(int ringNum = 0; ringNum < total_ring_num; ++ringNum) {
            d_out_ring[6 * ringNum + 1] = a;
            d_out_ring[6 * ringNum + 3] = b;
            d_out_ring[6 * ringNum + 5] = c;
        }

        for(int j = tid; j < cc_len; ++j) {
            if(d_cc[j] == a || d_cc[j] == b || d_cc[j] == c) {
                continue;
            }

            for(int k = j + 1; k < cc_len; ++k) {
                if(d_cc[k] == a || d_cc[k] == b || d_cc[k] == c || j == k) {
                    continue;
                }

                if(d_cc[j] == d_cc[k]) {
                    if(d_cc[(j + cc_len_half) % cc_len] == a && d_cc[(k + cc_len_half) % cc_len] == b || d_cc[(j + cc_len_half) % cc_len] == b && d_cc[(k + cc_len_half) % cc_len] == a) {
                        int repeat = total_ring_num / d_connector_num[i * 3 + 0];
                        for(int z = 0; z < repeat; ++z) {
                            d_out_ring[6 * i + 6 * z + 6 * a_b_cnt + 0] = d_cc[k];
                        }
                        ++a_b_cnt;
                    }

                    if(d_cc[(j + cc_len_half) % cc_len] == b && d_cc[(k + cc_len_half) % cc_len] == c || d_cc[(j + cc_len_half) % cc_len] == c && d_cc[(k + cc_len_half) % cc_len] == b) {
                        int repeat = total_ring_num / d_connector_num[i * 3 + 1];
                        for(int z = 0; z < repeat; ++z) {
                            d_out_ring[6 * i + 6 * z + 6 * b_c_cnt + 2] = d_cc[k];
                        }
                        ++b_c_cnt;
                    }
                
                    if(d_cc[(j + cc_len_half) % cc_len] == c && d_cc[(k + cc_len_half) % cc_len] == a || d_cc[(j + cc_len_half) % cc_len] == a && d_cc[(k + cc_len_half) % cc_len] == c) {
                        int repeat = total_ring_num / d_connector_num[i * 3 + 2];
                        for(int z = 0; z < repeat; ++z) {
                            d_out_ring[6 * i + 6 * z + 6 * c_a_cnt + 4] = d_cc[k];
                        }
                        ++c_a_cnt;
                    }
                }
            }
        }
        
        /*
        for(int tup1 = 0; tup1 < d_connector_num[tup1]; ++tup1) {
            for(int tup2 = 0; tup2 < d_connector_num[tup2]; ++tup2) {
                for(int tup3 = 0; tup2 < d_connector_num[tup3]; ++tup3) {

                }
            }
        }
        */
        
        /*
        for(int search = 0; search < total_ring_num; ++search) {
            d_out_ring[6 * search + 1] = a;
            d_out_ring[6 * search + 3] = b;
            d_out_ring[6 * search + 5] = c;

            for(int j = tid; j < cc_len; j += num_threads) {
                if(d_cc[j] == a || d_cc[j] == b || d_cc[j] == c) {
                    continue;
                }

                //int a_b_store = -100, b_c_store = -100, int c_a_store = -100;
                //int total = 0;

                for(int k = j + 1; k < cc_len; ++k) {

                    if(d_cc[k] == a || d_cc[k] == b || d_cc[k] == c || j == k) {
                        continue;
                    }

                    if(d_cc[j] == d_cc[k]) {
                        if(d_cc[(j + cc_len_half) % cc_len] == a && d_cc[(k + cc_len_half) % cc_len] == b || d_cc[(j + cc_len_half) % cc_len] == b && d_cc[(k + cc_len_half) % cc_len] == a) {
                                //a_b_store = d_cc[k];
                                printf("a_b is %d", d_connector_num[j]);
                                d_out_ring[6 * search + 0] = d_cc[k];
                                ++a_b_cnt;
                        }

                        if(d_cc[(j + cc_len_half) % cc_len] == b && d_cc[(k + cc_len_half) % cc_len] == c || d_cc[(j + cc_len_half) % cc_len] == c && d_cc[(k + cc_len_half) % cc_len] == b) {
                                //b_c_store = d_cc[k];
                                d_out_ring[6 * search + 2] = d_cc[k];
                                ++b_c_cnt;
                        }
                    
                        if(d_cc[(j + cc_len_half) % cc_len] == c && d_cc[(k + cc_len_half) % cc_len] == a || d_cc[(j + cc_len_half) % cc_len] == a && d_cc[(k + cc_len_half) % cc_len] == c) {
                                //printf("Entry added with %dth ring in %d\n", search, d_cc[k]);
                                d_out_ring[6 * search + 4] = d_cc[k];
                                ++c_a_cnt;
                        }
                    }

                    //total = a_b_cnt * b_c_cnt * c_a_cnt;                
                    //if(total > 0) {
                    //    printf("Entry added with %dth ring\n", constructed_ring);
                    //    ++constructed_ring;
                    //}
                }
            }
        }
        */
    }
}

__global__ void addNO2(int* d_c6, int ring_num, int* d_cn, int cn_size, int* d_no, int no_size, int* d_out) {
    int tid = blockDim.x * blockIdx.x + threadIdx.x;
    int num_threads = blockDim.x * gridDim.x;

    for(int i = 0; i < ring_num; ++i) {
        for(int j = 0; j < 6; ++j) {
            d_out[15 * i + j] = d_c6[6 * i + j];

            int cn = d_c6[6 * i + j];
            if(j == 1) {
                for(int k = tid; k < cn_size; k += num_threads) {
                    if(cn == d_cn[k]) {
                        d_out[15 * i + 6] = d_cn[k + cn_size];
                        int cnt = 0, n = d_cn[k + cn_size];
                        for(int l = 0; l < no_size; ++l) {
                            if(n == d_no[l]) {
                                if(cnt == 0) {
                                    d_out[15 * i + 9 + cnt] = d_no[l + no_size];
                                    ++cnt;
                                } else {
                                    d_out[15 * i + 9 + cnt] = d_no[l + no_size];
                                }
                            }
                        }
                    }
                }
            } else if (j == 3) {
                for(int k = tid; k < cn_size; k += num_threads) {
                    if(cn == d_cn[k]) {
                        d_out[15 * i + 7] = d_cn[k + cn_size];
                        int cnt = 0, n = d_cn[k + cn_size];
                        for(int l = 0; l < no_size; ++l) {
                            if(n == d_no[l]) {
                                if(cnt == 0) {
                                    d_out[15 * i + 11 + cnt] = d_no[l + no_size];
                                    ++cnt;
                                } else {
                                    d_out[15 * i + 11 + cnt] = d_no[l + no_size];
                                }
                            }
                        }
                    }
                }
            } else if(j == 5) {
                for(int k = tid; k < cn_size; k += num_threads) {
                    if(cn == d_cn[k]) {
                        d_out[15 * i + 8] = d_cn[k + cn_size];
                        int cnt = 0, n = d_cn[k + cn_size];
                        for(int l = 0; l < no_size; ++l) {
                            if(n == d_no[l]) {
                                if(cnt == 0) {
                                    d_out[15 * i + 13 + cnt] = d_no[l + no_size];
                                    ++cnt;
                                } else {
                                    d_out[15 * i + 13 + cnt] = d_no[l + no_size];
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

/*
__global__ void add48Mappings(int* d_tnt, int ring_num, int* d_out) {

    // (012345 678) (9 10) (11 12) (13 14)
    
    for(int ring = 0; ring < ring_num; ++ring) {
        int base = 15 * 48 * ring;

        for(int i = 0; i < 6; ++i) {
        
            d_out[base + i] = d_tnt[15 * ring_num + i];


            for(int j = 0; j < 2; ++j) {


                for(int k = 0; k < 2; ++k) {


                    for(int l = 0; l < 2; ++l) {



                    }
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

            // validate c with n02
            int* d_cn;
            bool *d_valid_cn_len;
            cudaMalloc((void**) &d_cn, 2 * c_n_size * sizeof(int));
            cudaMalloc((void**) &d_valid_cn_len, c_n_size * sizeof(bool));

            int* d_no, *d_valid_no;
            cudaMalloc((void**) &d_no, 2 * n_o_size * sizeof(int));
            cudaMalloc((void**) &d_valid_no, 2 * n_o_size * sizeof(int));

            cudaMemcpy(d_no, n_o, 2 * n_o_size * sizeof(int), cudaMemcpyHostToDevice);
            cudaMemcpy(d_cn, c_n, 2 * c_n_size * sizeof(int), cudaMemcpyHostToDevice);
            
            valid_n_counter<<<num_blocks_per_grid, num_threads_per_block>>>(d_cn, c_n_size, d_no, n_o_size, d_valid_cn_len);
            cudaDeviceSynchronize();

            bool * h_valid_cn = (bool*) malloc(c_n_size * sizeof(bool));
            cudaMemcpy(h_valid_cn, d_valid_cn_len, c_n_size * sizeof(bool), cudaMemcpyDeviceToHost);


            /*
            //1 1 1
            for(int i = 0; i < c_n_size; ++i) {
                std::cout << h_valid_cn[i] << " ";
            }
            std::cout << std::endl;
            */

            // 3 -> therefore only 1 combination possible
            int good_cno2_num = 0;
            for(int i = 0; i < c_n_size; ++i) {
                if(h_valid_cn[i] == true) {
                    ++good_cno2_num;
                }
            }

            // all possible # of combination;
            unsigned int comb_cnt = 1;
            for(int i = good_cno2_num; i > good_cno2_num - 3; --i) {
                comb_cnt *= i;
            }
            comb_cnt /= 6;

            // filter out and create tuple array

            int* d_3_tuple;
            cudaMalloc((void**) &d_3_tuple, 3 * comb_cnt * sizeof(int));
            cudaMemcpy(d_3_tuple, h_valid_cn, c_n_size * sizeof(int), cudaMemcpyHostToDevice);

            combination_generator<<<num_blocks_per_grid, num_threads_per_block>>>(d_cn, d_valid_cn_len, c_n_size, d_3_tuple);
            cudaDeviceSynchronize();

            int* h_3_tuple = (int*) malloc(3 * comb_cnt * sizeof(int));
            cudaMemcpy(h_3_tuple, d_3_tuple, 3 * comb_cnt * sizeof(int), cudaMemcpyDeviceToHost);



            // prints out 0 2 4
            /*
            for(int i = 0; i < comb_cnt; ++i) {
                for(int j = 0; j < 3; ++j) {
                    std::cout << h_3_tuple[i * 3 + j] << " ";
                }
                std::cout << std::endl;
            }
            */

            // c1 c2 c3 사이에 1, 1, 2 이거 알려주는거임
            int *d_c_c;
            cudaMalloc((void**) &d_c_c, c_c_size * sizeof(int)); 
            cudaMemcpy(d_c_c, c_c, c_c_size * sizeof(int), cudaMemcpyHostToDevice);


            int *d_connector_num;
            cudaMalloc((void**) &d_connector_num, 3 * comb_cnt * sizeof(int));

            find_connectors<<<num_blocks_per_grid, num_threads_per_block>>>(d_c_c, c_c_size, d_3_tuple, comb_cnt * 3, d_connector_num);
            cudaDeviceSynchronize();

            int *h_connector_num = (int*) malloc(comb_cnt * 3 * sizeof(int));
            cudaMemcpy(h_connector_num, d_connector_num, 3 * sizeof(int), cudaMemcpyDeviceToHost);
            

            /*
            std::cout << "number of each connectors called createRing_fin" << std::endl;
            for(int i = 0; i < comb_cnt * 3 ; ++i) {
                std::cout << h_connector_num[i] << " ";
            }
            std::cout << std::endl;
            */

            int total_rings = 0;

            for(int i = 0; i < comb_cnt * 3; i += 3) {
                int temp = 1;
                for(int j = 0; j < 3; ++j) {
                    temp *= h_connector_num[i * 3 + j];
                }
                total_rings += temp;
            }

            //std::cout << "Total ring num is " << total_rings << std::endl;

            //cudaMemcpy(d_connector_num, h_connector_num, 3 * sizeof(int), cudaMemcpyHostToDevice);

            int *d_rings;
            cudaMalloc((void**) &d_rings, total_rings * 6 * sizeof(int));

            int *h_rings = (int*) malloc(total_rings * 6 * sizeof(int));

            // int* d_cc, int cc_len, int* d_c_tuple, int tuple_len, int* d_connector_num,
            // int d_connector_num_size, int total_ring_num, int* d_out_ring

            createRing<<<num_blocks_per_grid, num_threads_per_block>>>(d_c_c, c_c_size, d_3_tuple, comb_cnt * 3, d_connector_num, total_rings, d_rings);
            cudaDeviceSynchronize();

            cudaMemcpy(h_rings, d_rings, total_rings * 6 * sizeof(int), cudaMemcpyDeviceToHost);


            /*
            std::cout << "h_ring start" << std::endl;
            for(int i = 0; i < total_rings; ++i) {
                for(int j = 0; j < 6; ++j) {
                    std::cout << h_rings[i * 6 + j] << " ";
                }
                std::cout << std::endl;
            } 
            */

            // Add NO2
            int* d_c6rings;
            cudaMalloc((void**) &d_c6rings, total_rings * 6 * sizeof(int));
            cudaMemcpy(d_c6rings, h_rings, total_rings * 6 * sizeof(int), cudaMemcpyHostToDevice);

            int * d_tnt;
            cudaMalloc((void**) &d_tnt, total_rings * 15 * sizeof(int));
            addNO2<<<num_blocks_per_grid, num_threads_per_block>>>(d_c6rings, total_rings, d_cn, c_n_size, d_no, n_o_size, d_tnt);
            cudaDeviceSynchronize();

            int* h_tnt = (int*) malloc(total_rings * 15 * sizeof(int));
            cudaMemcpy(h_tnt, d_tnt, (total_rings * 15 * sizeof(int)), cudaMemcpyDeviceToHost);


            /*
            for(int i = 0; i < total_rings; ++i) {
                for(int j = 0; j < 15; ++j) {
                    std::cout << h_tnt[i * 15 + j] << " ";
                }
                std::cout << std::endl;
            }
            */

            // 48 Mappings
            /*
            int * d_tnt_48;
            cudaMalloc((void**) &d_tnt_48, total_rings  * 15 * 48 * sizeof(int));

            add48Mappings<<<num_blocks_per_grid, num_threads_per_block>>>(d_tnt, total_rings, d_tnt_48);
            cudaDeviceSynchronize();
            int* h_tnt_48;
            cudaMemcpy(h_tnt_48, d_tnt_48, (total_rings  * 15 * 48 * sizeof(int)), cudaMemcpyDeviceToHost);
            */

            
            /*
            int* temp = (int*) malloc(total_rings * 48 * 15 * sizeof(int));
            for(int i = 0; i < total_rings * 48; ++i) {
                for(int k = 0; k < 15; ++k) {
                    temp[15 * i + k] = 1;
                }
            }
            h_tnt_48 = temp;
            */

            final_result_size = total_rings * 48;
            final_results = (int*) malloc(final_result_size * 15 * sizeof(int));

            for (int i = 0; i < total_rings; i++) {

                int* c6_rings = (int*) malloc(6 * sizeof(int));
                int* n3_array = (int*) malloc(3 * sizeof(int));
                int* o6_array = (int*) malloc(6 * sizeof(int));

                for(int j = 0; j < 6; ++j) {
                    c6_rings[j] = h_tnt[i * 15 + j];
                }

                for(int j = 0; j < 3; ++j) {
                    n3_array[j] = h_tnt[i * 15 + j + 6];
                }
            
                for(int j = 0; j < 6; ++j) {
                    o6_array[j] = h_tnt[i * 15 + j + 9];    
                }
                
                for(int j = 0; j < 48; ++j) {
                    for (int k = 0; k < NUM_TNT_VERTICES; k++) {
                        if(0 <= k && k <= 5) //c6
                        {
                            final_results[k * final_result_size + (48 * i + j)] = c6_rings[k];
                        }
                        
                        else if(6 <= k && k <= 8) //n3
                        {
                            final_results[k * final_result_size + (48 * i + j)] = n3_array[k % 3];
                        }
                        
                        else // o6
                        {
                            //std::cout << "o6 index is " <<  k % 6 << std::endl;
                            //std::cout << "o6 arrays gives " <<  o6_array[k % 6] << std::endl;
                            final_results[k * final_result_size + (48 * i + j)] = o6_array[k % 6];
                        }
                    }
                }

                for(int j = 0; j < final_result_size; j +=8) {
                    for(int k = 0; k < 6; ++k) {
                        //h_tnt_48[k * final_result_size + (48 * i + j)] = h_tnt_48[];
                    }
                }
            }

            //final_results = h_tnt_48;
            // freememory
            cudaFree(d_cn);
            cudaFree(d_valid_cn_len);
            cudaFree(d_no);
            cudaFree(d_valid_no);
            cudaFree(d_3_tuple);
            cudaFree(d_valid_no);
            cudaFree(d_c_c);
            cudaFree(d_connector_num);
            cudaFree(d_rings);
            cudaFree(d_tnt);
            cudaFree(d_c6rings);

            free(h_rings);
            free(h_valid_cn);
            free(h_3_tuple);
            free(h_connector_num);
            free(h_tnt);

            /*
            for (int i = 0; i < total_rings; i++) {
                    for(int j = 0; j < 48; ++j) {
                        for (int k = 0; k < NUM_TNT_VERTICES; k++) {

                            h_tnt_48[k * final_result_size + (48 * i + j)] = 0;
                    }
                }
            }

            for(int i = 0; i < total_rings; ++i) {

                int* c6_rings = (int*) malloc(6 * sizeof(int));
                int* n3_array = (int*) malloc(3 * sizeof(int));
                int* o6_array = (int*) malloc(6 * sizeof(int));

                for(int j = 0; j < 6; ++j) {
                    c6_rings[j] = h_tnt[i * 15 + j];
                }

                for(int j = 0; j < 3; ++j) {
                    n3_array[j] = h_tnt[i * 15 + j + 6];
                }
            
                for(int j = 0; j < 6; ++j) {
                    o6_array[j] = h_tnt[i * 15 + j + 9];    
                }

                for (int j = 0; j < 48; ++j) {
                    for (int k = 0; k < 15; ++k) {
                        h_tnt[k * final_result_size + j] = 0;
                    }
                }

            */
                /*

                for(int j = 0; j < 6; ++j) {
                    h_tnt_48[48 * i + ((j + shift) % 6) +  k] = c6_rings[j];
                }

                for(int shift = 0; shift < 6; ++shift) {
                    for(int j = 0; j < 6; ++j) {
                        for(int k = 0; k < 8; ++k) {
                            h_tnt_48[48 * i + ((j + shift) % 6) +  k] = c6_rings[j];
                        }
                    }
                }
                */

                /*

                for(int shift = 0; shift < 3; ++shift) {
                    for(int j = 0; j < 3; ++j) {
                        for(int k = 0; k < 8; ++k) {
                            h_tnt_48[(48 * 15 * i + 6) + ((j + shift) % 3) +  k * 15] = n3_array[j];
                        }
                    }
                }
            
                for(int j = 0; j < 3; ++j) {
                    for(int k = 0; k < 2; ++k) {
                        if(j == 0) {
                            for(int row = 0; row < 2; ++row) {
                                for(int pat = 0; pat < 4; ++pat) {
                                    h_tnt_48[(48 * 15 * i + 9 + j * 2) + (row) + pat * 15] = o6_array[2 * j + k];
                                }
                            }
                        } else if(j == 1) {
                            for(int row = 0; row < 4; ++row) {
                                for(int pat = 0; pat < 2; ++pat) {
                                    h_tnt_48[(48 * 15 * i + 9 + j * 2) + (row % 2) +  (row * 2 + pat) * 15] = o6_array[2 * j + k];
                                }
                            }
                        } else {
                            for(int row = 0; row < 8; ++row) {
                                h_tnt_48[(48 * 15 * i + 9 + j * 2) +  row * 15 + row % 2] = o6_array[2 * j + k];
                            }
                        }
                    }
                }
                
            }
            */


            /*
            int *h_valid_no = (int*) malloc(n_o_size * sizeof(int)), *h_valid_no_len = (int*) malloc(sizeof(int));
            cudaMemcpy(h_valid_no, d_valid_no, n_o_size * sizeof(int), cudaMemcpyDeviceToHost);
            cudaMemcpy(h_valid_no_len, d_valid_no_len, sizeof(int), cudaMemcpyDeviceToHost);

            //std::cout << "valid_no2_len is " << h_valid_no_len[0] << std::endl;

            for(int i = 0; i < h_valid_no_len[0]; ++i)
                std::cout << h_valid_no[i] << " ";
            std::cout << std::endl;

            // Assume that all N are valid
            h_valid_no_len[0] = 3;
            h_valid_no[0] = 6; h_valid_no[1] = 7; h_valid_no[2] = 8;
            
            int *d_valid_cn, *d_valid_cn_len;
            //cudaMalloc((void**) &d_cn, c_n_size * sizeof(int));
            cudaMalloc((void**) &d_valid_cn, c_n_size * sizeof(int));
            cudaMalloc((void**) &d_valid_cn_len, sizeof(int));
            cudaMemcpy(d_cn, c_n, n_o_size * sizeof(int), cudaMemcpyHostToDevice);

            int* h_valid_c = (int*) malloc(3 * sizeof(int));
            h_valid_c[0] = 0; h_valid_c[1] = 2; h_valid_c[2] = 4;

            int* d_valid_c;
            cudaMalloc((void **) &d_valid_c, 3 * sizeof(int));
            cudaMemcpy(d_valid_c, h_valid_c, 3 * sizeof(int), cudaMemcpyHostToDevice);

            // for each 3-tuple, return the number of possible connectors between ab, bc, and ac
            // ex) output: c1c2c3 1 1 2 means that there are total possible c1-X-c2-Y-c3-Z1 and c1-X-c2-Y-c3-Z2

            int* d_valid_c_ring;
            cudaMalloc((void **) &d_valid_c_ring, 3 * sizeof(int));

            int *d_c_c;
            cudaMalloc((void**) &d_c_c, c_c_size * sizeof(int)); 
            cudaMemcpy(d_c_c, c_c, c_c_size * sizeof(int), cudaMemcpyHostToDevice);
            
            int *d_c_c_connectors;
            cudaMalloc((void**) &d_c_c_connectors, c_c_size * sizeof(int)); 

            int *d_ring_num;
            cudaMalloc((void**) &d_ring_num, c_c_size * sizeof(int));

            int *h_c_c_connectors = (int*) malloc(c_c_size * sizeof(int));
            int *h_ring_num = (int*) malloc( sizeof(int));
            int *h_valid_c_ring = (int*) malloc(3 * sizeof(int));

            // int* d_cc, int cc_len, int* d_cn, int cn_len, int* d_out_c_part, int* d_out_connector, int* tuple_num
            // tuple_connector<<<num_blocks_per_grid, num_threads_per_block>>>(d_c_c, c_c_size, d_valid_c, 3, h_valid_c_ring, d_c_c_connectors, d_ring_num);
            // cudaDeviceSynchronize();

            cudaMemcpy(h_c_c_connectors, d_c_c_connectors, c_c_size * sizeof(int), cudaMemcpyDeviceToHost);
            cudaMemcpy(h_valid_c_ring, d_valid_c_ring, 3 * sizeof(int), cudaMemcpyDeviceToHost);
            cudaMemcpy(h_ring_num, d_ring_num, sizeof(int), cudaMemcpyDeviceToHost);

            std::cout << "h_valid_c_ring is " << h_ring_num[0] << std::endl;
            
            for(int i = 0; i < h_ring_num[0]; ++i) {
                for(int j = 0; j < 3; ++j) {
                    std::cout << h_valid_c_ring[i * 3 + j] << " "  << h_c_c_connectors[i * 3 + j] << std::endl;
                }
                std::cout << std::endl;
            }
            std::cout << std::endl;
            

            // create discrete rings of 6 carbon atoms

            int *d_connector_num;
            cudaMalloc((void**) &d_connector_num, 3 * sizeof(int));

            int d_rings_len = 1;
            int *h_connector_num = (int*) malloc(3 * sizeof(int));

            //int* d_cc, int cc_len, int* d_c_tuple, int tuple_len, int total_ring_num, int* d_out_ring
            createRing_fin<<<num_blocks_per_grid, num_threads_per_block>>>(d_c_c, c_c_size, d_valid_c, 3, d_connector_num);
            cudaDeviceSynchronize();
            cudaMemcpy(h_connector_num, d_connector_num, 3 * sizeof(int), cudaMemcpyDeviceToHost);

            std::cout << "number of each connectors called createRing_fin" << std::endl;
            int total_rings = 1;
            for(int i = 0; i < 3; i += 3) {
                for(int j = 0; j < 3; ++j) {
                    total_rings *= h_connector_num[i * 3 + j];
                }
            }

            for(int i = 0; i < 3; ++i) {
                std::cout << h_connector_num[i] << " ";
            }
            std::cout << std::endl;

            cudaMemcpy(d_connector_num, h_connector_num, 3 * sizeof(int), cudaMemcpyHostToDevice);

            int *d_rings;
            cudaMalloc((void**) &d_rings, total_rings * 6 * sizeof(int));

            int *h_rings = (int*) malloc(total_rings * 6 * sizeof(int));

            createRing<<<num_blocks_per_grid, num_threads_per_block>>>(d_c_c, c_c_size, d_valid_c, d_rings_len, d_connector_num, 3, total_rings, d_rings);
            cudaDeviceSynchronize();

            cudaMemcpy(h_rings, d_rings, total_rings * 6 * sizeof(int), cudaMemcpyDeviceToHost);

            std::cout << "h_ring started" << std::endl;
            for(int i = 0; i < total_rings; ++i) {
                for(int j = 0; j < 6; ++j) {
                    std::cout << h_rings[i * 6 + j] << " ";
                }
                std::cout << std::endl;
            } 


            */


            // add the corresponding N

            // add the corresponding O

            // permute to create 48 rings

            // store it to final_results and final_result_size

            // free all memory

            /*
            // maksing unique c starting points
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
            cudaDeviceSynchronize();
            cudaMemcpy(h_unique_c_mask, d_unique_c_mask, (c_c_size / 2) * sizeof(bool), cudaMemcpyDeviceToHost);

            for(int i = 0; i < c_c_size / 2; ++i) {
                std::cout << h_unique_c_mask[i] << std::endl; 
            }
            
            cudaFree(d_c_c);
            cudaFree(d_unique_c_mask);
            cudaFree(d_c_visited);
            free(h_unique_c_mask);
            free(h_c_visited);
            */
}

/*
Input : cn array and no array
Output: id of n with 2 oxygens
*/
__global__ void valid_n(int* d_no, int no_len, int* d_valid_no, int* d_valid_no_len) {
    int tid = blockDim.x * blockIdx.x + threadIdx.x;
    int num_threads = blockDim.x * gridDim.x;

    // bring in c_n and n_o array
    int valid_no_len = 0;
    int cnt = 0;
    for(int i = tid; i < no_len; i += num_threads) {
        cnt = 0; 
        for(int j = 0; j < no_len; ++j) {
            if(d_no[i] == d_no[j]) {
                ++cnt;
            }
        }
        
        if(cnt == 2) {
            //printf("%d has 2 counts\n", d_no[i]);
            d_valid_no[i] = d_no[i];
            ++valid_no_len; 
        }
    }
    
    d_valid_no_len[0] = valid_no_len;
}

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

//printf("a is %d\n", a); printf("b is %d\n", b); printf("c is %d\n", c);

/*
__global__ void tuple_connector(int* d_cc, int cc_len, int* d_cn, int cn_len, int* d_out_c_part, int* d_out_connector, int* tuple_num) {
    int tid = blockDim.x * blockIdx.x + threadIdx.x;
    int num_threads = blockDim.x * gridDim.x;
    int cc_len_half = cc_len / 2;

    int valid_ring = 0;

    for(int i = tid; i < cn_len; i += num_threads) {
        for(int j = i + 1; j < cn_len; ++j) {
            for(int k = j + 1; k < cn_len; ++k) {
                int a = d_cn[i], b = d_cn[j], c = d_cn[k];
                int a_b_cnt = 0, b_c_cnt = 0, c_a_cnt = 0; 
                
                for(int l = 0; l < cc_len; ++l) {
                    if(d_cc[l] == a || d_cc[l] == b || d_cc[l] == c) {
                        //printf("First continue %d\n", d_cc[l]);
                        continue;
                    }

                    for(int m = l + 1; m < cc_len; ++m) {
                        //printf("Second continue\n");
                        if(d_cc[m] == a || d_cc[m] == b || d_cc[m] == c) {
                            continue;
                        }

                        //printf("%d vs %d\n", d_cc[l], d_cc[m]);
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
                        //printf("a_b is %d b_c is %d c_a is %d\n", a_b_cnt, b_c_cnt, c_a_cnt);
                    }
                }
                int total = a_b_cnt * b_c_cnt * c_a_cnt;
                printf("total value is %d\n", total);
                if(total == 0) {
                    printf("why?\n");
                    continue;
                } else {
                    d_out_c_part[valid_ring * 3 + 0] = a;
                    d_out_c_part[valid_ring * 3 + 1] = b;
                    d_out_c_part[valid_ring * 3 + 2] = c;
                    d_out_connector[valid_ring * 3 + 0] = a_b_cnt;
                    d_out_connector[valid_ring * 3 + 1] = b_c_cnt;
                    d_out_connector[valid_ring * 3 + 2] = c_a_cnt;
                    ++valid_ring;
                    tuple_num[0] = total;

                    //for(int tup1 = 0; tup1 < a_b_cnt; ++tup1) {
                    //    for(int tup2 = 0; tup2 < b_c_cnt; ++tup2) {
                    //        for(int tup3 = 0; tup3 < c_a_cnt; ++tup3) {
                    //            d_out_c_part[valid_ring * 3 + 1] = a;
                    //            d_out_c_part[valid_ring * 3 + 3] = b;
                    //            d_out_c_part[valid_ring * 3 + 5] = c;
                    //            d_out_connector[a_b_cnt * 3 + 0] = a_b_cnt;
                    //            d_out_connector[b_c_cnt * 3 + 2] = b_c_cnt;
                    //            d_out_connector[c_a_cnt * 3 + 4] = c_a_cnt;
                    //            ++valid_ring;
                    //        }
                    //    }
                    //}
    
                }
            } 
        }
    }
    //tuple_num[0] = valid_ring;
}
*/

/*
for(int shift = 0; shift < 3; ++shift) {
    for(int j = 0; j < 6; ++j) {
        for(int k = 0; k < 8; ++k) {
            h_tnt_48[(48 * 15 * i + 9) + j +  k * 15] = n3_array[j];
        }
    }
}

                
for(int j = 0; j < 2; ++j) {
    for(int k = 0; k < 2; ++k) {
        for(int l = 0; l < 2; ++l) {
            for(int eachrow = 0; eachrow < 8; ++eachrow) {
                h_tnt_48[(48 * 15 * i + 9) + ((j + shift) % 3) +  eachrow * 15] = o6_array[4 * j + 2 * k + l];
            }
        }
    }
}
*/
