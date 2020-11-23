#include <iostream>

// Calculate the multiplication of two 32*32 matrices A and B on gpu and store the result in C.
// Each block calculate one element of C.
__global__ void Mul(int* d_A, int* d_B, int* d_C) {
    int tid = blockDim.x * blockIdx.x + threadIdx.x;
	int num_threads = blockDim.x * gridDim.x;

    for (int i = tid; i < 32 * 32; i += num_threads) {
       	int row = i / 32;
       	int col = i % 32;
		d_C[row * 32 + col] = 0;

		// sum of d_A(row, i) * d_B(i, col)
       	for(int j = 0; j < 32; j++) {
       		d_C[row * 32 + col] += d_A[row * 32 + j] * d_B[j * 32 + col];
       	}
	}
}

int main() {
	int *A = (int*)malloc(32 * 32 * sizeof(int));
	int *B = (int*)malloc(32 * 32 * sizeof(int));

	for(int i = 0; i < 32 * 32; i++) {
        	A[i] = 1;
        	B[i] = 1;
	}

	//Allocate the memory in GPU to store the content of A,B,C
	int *d_A, *d_B, *d_C;
	cudaMalloc((void **)&d_A, 32 * 32 * sizeof(int));
	cudaMalloc((void **)&d_B, 32 * 32 * sizeof(int));
	cudaMalloc((void **)&d_C, 32 * 32 * sizeof(int));

	//Copy A, B to d_A,d_B
	cudaMemcpy(d_A, A, 32 * 32 * sizeof(int), cudaMemcpyHostToDevice);
	cudaMemcpy(d_B, B, 32 * 32 * sizeof(int), cudaMemcpyHostToDevice);

	Mul<<<4,32>>>(d_A, d_B, d_C);

	int *C = (int*)malloc(32 * 32 * sizeof(int));
	cudaMemcpy(C, d_C, 32 * 32 * sizeof(int), cudaMemcpyDeviceToHost);

	//print the result
	for(int i = 0; i < 32; i++) {
		for(int j = 0; j < 32; j++) {
			std::cout << C[i * 32 + j] << " ";
		}
		std::cout << std::endl;
	}

	cudaFree(d_A);
	cudaFree(d_B);
	cudaFree(d_C);

	free(A);
	free(B);
	free(C);

	return 0;
}

