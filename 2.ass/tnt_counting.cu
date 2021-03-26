#include <iostream>
#include "helpers.h"

using namespace std;
/* you can define data structures and helper functions here */


/**
 * please remember to set final_results and final_result_size 
 * before return.
 */
void tnt_counting(int num_blocks_per_grid, int num_threads_per_block,
        int* c_c, int* c_n, int* c_h, int* n_o,
        int c_c_size, int c_n_size, int c_h_size, int n_o_size,
        int* &final_results, int &final_result_size) {

    cout << num_blocks_per_grid << endl;
    cout << num_threads_per_block << endl;
    
    for(int i = 0; i < c_c_size; ++i)
        cout << c_c[i] << " ";

    cout << endl;

    for(int i = 0; i < c_n_size; ++i)
        cout << c_n[i] << " ";

    cout << endl;


    for(int i = 0; i < c_h_size; ++i)
        cout << c_h[i] << " ";

    cout << endl;

    for(int i = 0; i < n_o_size; ++i)
        cout << n_o[i] << " ";

    cout << endl;
}
