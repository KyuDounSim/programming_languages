/**
 *	Demo code of Cuda programming lecture
 *	
 *	This programme illustrates how warp divergence may influence the performance of CUDA programme
 *
 *
 */
#include <cstdio>
#include <cstdlib>
#include <sys/time.h>

#define HALF_BLOCK_SIZE 512
#define BLOCK_SIZE 1024
#define LOOP_NUM 1024

//Kernel1 (has warp divergence)
__global__ void kernel1(int *A, int *B)
{
	int i = blockIdx.x*blockDim.x + threadIdx.x;	

	if (i % 2 == 0)
	{
		/*Execution Path 1: thread 0, 2, 4, 6...30... reach here*/
		
		int lower_bound = B[i];
		int tmp = 0;
		
		//do some computation to make this execution path long enough
		for (int j = lower_bound; j < lower_bound+LOOP_NUM; j += 2)	
			tmp += j;
		A[i] += tmp;
	}
	else
	{
		/*Execution Path 2: thread 1, 3, 5, 7...31... reach here*/

		int lower_bound = B[i];
		int tmp = 0;
		
		//do some computation to make this execution path long enough
		for (int j = lower_bound; j < lower_bound+LOOP_NUM; j += 2)	
			tmp += j;

		A[i] -= tmp;
	}
		
 	/*even threads and odd threads go back to the same exexution path*/
}

//Kerne2 (does not have warp divergence)
__global__ void kernel2(int *A, int *B)
{
	int base = blockIdx.x*blockDim.x;	
	
	if (threadIdx.x < HALF_BLOCK_SIZE)
	{
		/*Execution Path 1: the first half threads of a block reach here*/

		int even_index = base + threadIdx.x*2;
		
		int lower_bound = B[even_index];
		int tmp = 0;
		
		//Do some computation
		for (int j = lower_bound; j < lower_bound+LOOP_NUM; j += 2)	
			tmp += j;

		A[even_index] += tmp;
	}
	else
	{
		/*Execution Path 2: the second half threads of a block reach here*/

		int odd_index = base + (threadIdx.x - HALF_BLOCK_SIZE)*2 +1;
		
		int lower_bound = B[odd_index];
		int tmp = 0;
		
		//Do some computation
		for (int j = lower_bound; j < lower_bound+LOOP_NUM; j += 2)	
			tmp += j;

		A[odd_index] -= tmp;
	}
}

int main()
{
	//Device and host memory pointers
	int *h_A, *h_B, *d_A, *d_B;
	
	int N = 33554432;
	int data_size = N*(sizeof(int));
	
	//Kernel configuration parameter
	int threads_per_block = BLOCK_SIZE;
	int blocks_per_grid = N / threads_per_block;
	
	//Time measurement
	timeval k1_start, k1_end, k2_start, k2_end;
	float k1_elapsed_time, k2_elapsed_time;
	
	//Allocate Host Memory
	h_A = (int*)malloc(data_size);
	h_B = (int*)malloc(data_size);
	
	//Allocate Device Memory
	cudaMalloc((void**)&d_A, data_size);
	cudaMalloc((void**)&d_B, data_size);
	
	//Initialization
	for (int i = 0; i < N; i++)
	{
		h_A[i] = i;
		h_B[i] = i;
	}
	
	//Memory copy from host to device
	cudaMemcpy(d_A, h_A, data_size, cudaMemcpyHostToDevice);
	cudaMemcpy(d_B, h_B, data_size, cudaMemcpyHostToDevice);
	
	
	gettimeofday(&k1_start, NULL);
	
	//Invoke kernel1(has warp divergence)
	kernel1<<<blocks_per_grid, threads_per_block>>>(d_A, d_B);

	cudaDeviceSynchronize();

	gettimeofday(&k1_end, NULL);


	gettimeofday(&k2_start, NULL);
	
	//Invoke kernel2(does not have warp divergence)
	kernel2<<<blocks_per_grid, threads_per_block>>>(d_A, d_B);

	cudaDeviceSynchronize();

	gettimeofday(&k2_end, NULL);

	//Copy result back from device to host
	cudaMemcpy(h_A, d_A, data_size, cudaMemcpyDeviceToHost);

	k1_elapsed_time = 1000*(k1_end.tv_sec - k1_start.tv_sec) + (float)(k1_end.tv_usec - k1_start.tv_usec)/1000;
	k2_elapsed_time = 1000*(k2_end.tv_sec - k2_start.tv_sec) + (float)(k2_end.tv_usec - k2_start.tv_usec)/1000;
	
	printf("elapsed time of kernel function which has warp divergence: %.2f ms\n", k1_elapsed_time);
	printf("elapsed time of kernel function which has no warp divergence: %.2f ms\n", k2_elapsed_time);
	
	//Free device memory
	cudaFree(d_A);
	cudaFree(d_B);
	
	//Free host memory
	free(h_A);
	free(h_B);

	return 0;
}

