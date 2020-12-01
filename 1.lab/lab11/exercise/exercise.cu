#include <iostream>
#include <fstream>

__global__ void common_elements(int* d_A, int* d_B, int* d_C) {
    int tid = blockDim.x * blockIdx.x + threadIdx.x;
	int num_threads = blockDim.x * gridDim.x;

	d_C[tid] = 0;
	
	// loop over A and B and count the number of common elements
	// add your code here

	for (int i = tid; i < 2048; i += num_threads) {
		for (int j = 0; j < 2048; ++j){
			if (d_A[i] == d_B[j]){
				++d_C[tid];
			}
		}
    }
}

int main() {
	int *A = (int*)malloc(2048 * sizeof(int));
	int *B = (int*)malloc(2048 * sizeof(int));

	// read files
	std::ifstream inputa("a.txt", std::ifstream::in);
	std::ifstream inputb("b.txt", std::ifstream::in);
	for (int i = 0; i < 2048; i++) {
		inputa >> A[i];
		inputb >> B[i];
	}

	int num_blocks_per_grid = 4;
	int num_threads_per_grid = 32;

	// Allocate the memory in GPU to store the content of A,B,C
	int *d_A, *d_B, *d_C;
	cudaMalloc((void **)&d_A, 2048 * sizeof(int));
	cudaMalloc((void **)&d_B, 2048 * sizeof(int));

	// d_C stores the number of common elements found by each thread
	cudaMalloc((void **)&d_C, num_blocks_per_grid * num_threads_per_grid * sizeof(int));

	// Copy A, B to d_A,d_B
	cudaMemcpy(d_A, A, 2048 * sizeof(int), cudaMemcpyHostToDevice);
	cudaMemcpy(d_B, B, 2048 * sizeof(int), cudaMemcpyHostToDevice);

	common_elements<<<num_blocks_per_grid,num_threads_per_grid>>>(d_A, d_B, d_C);

	int *C = (int*)malloc(num_blocks_per_grid * num_threads_per_grid * sizeof(int));
	cudaMemcpy(C, d_C, num_blocks_per_grid * num_threads_per_grid* sizeof(int), cudaMemcpyDeviceToHost);
	
	int num_common_elements = 0;

    for (int i = 0; i < num_blocks_per_grid * num_threads_per_grid; i++) {
		num_common_elements += C[i];
	}

	// print the number of common elements
	std::cout << num_common_elements << std::endl;

	cudaFree(d_A);
	cudaFree(d_B);
	cudaFree(d_C);

	free(A);
	free(B);
	free(C);

	return 0;
}
