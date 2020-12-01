/**
 *	Demo code of Cuda programming lecture
 *	
 *	This programme illustrates the benefit of using shared memory
 *
 *
 */

#include <cstdio>
#include <cstdlib>
#include <sys/time.h>

//Kernel function that does not use shared memory, each memory read is from global memory
 __global__ void compute_no_shared_memory(int *data)
{
     int tid = threadIdx.x;
     int* base = data + blockIdx.x * blockDim.x;
     int tmp = 0;
	
     //Do some computation 	
     for (int i = 0; i < tid; i++)
	     tmp += base[i];
     
     //Make sure all threads in a block have completed computation	
     //__syncthreads();	

     base[tid] = tmp + base[tid];
}

//Kernel function that utilizes shared memory
 __global__ void compute_use_shared_memory(int *data)
{
     int tid = threadIdx.x;
     int* base = data + blockIdx.x * blockDim.x;
     int tmp = 0;

     __shared__ int myblock[1024];

     // load data from global memory to shared memory
     myblock[tid] = base[tid];

     // ensure that all threads have loaded their values into
     // shared memory; Otherwise, one thread might be computing
     // on unitialized data.
     __syncthreads();

     //Do some computation 	
     for (int i = 0; i < tid; i++) 
	     tmp += myblock[i];   

     // write the result back to global memory
     base[tid] = tmp + myblock[tid];
}

int main()
{	
	//Host and device pointers
	int * h_data, *d_data;
	int N = 33554432;
	int data_size = N * sizeof(int);
	
	//Kernel configuration parameters
	int threads_per_block = 1024;
	int blocks_per_grid = N / threads_per_block;
	
	//For time measurement
	timeval start, end;
	float elapsed_time_use_shared_m;
	float elapsed_time_no_shared_m;
	
	//Host memory allocation
	h_data = (int*)malloc(data_size);
	
	//Device memory allocation
	cudaMalloc((void**)&d_data, data_size);
	
	//Initialization
	for (int i = 0; i < N; i++)
		h_data[i] = i;
	
	//Memory copy from the host to the device
	cudaMemcpy(d_data, h_data, data_size, cudaMemcpyHostToDevice);
	
	//Start timer
	gettimeofday(&start, NULL);
	
	//Invoke the kernel that utilize shared memory
	compute_use_shared_memory<<<blocks_per_grid, threads_per_block>>>(d_data);
	
	//Wait for kernel execution
	cudaDeviceSynchronize();
	
	//End timer
	gettimeofday(&end, NULL);
	
	//Calculate elapsed time
	elapsed_time_use_shared_m = 1000*(end.tv_sec-start.tv_sec) + (float)(end.tv_usec - start.tv_usec)/1000;
	
	//Copy data to device memory
	cudaMemcpy(d_data, h_data, data_size, cudaMemcpyHostToDevice);

	//Start timer
	gettimeofday(&start, NULL);
	
	//Invoke the kernel that does not use shared memory
	compute_no_shared_memory<<<blocks_per_grid, threads_per_block>>>(d_data);
	
	//Wait for kernel execution
	cudaDeviceSynchronize();
	
	//End timer
	gettimeofday(&end, NULL);
	
	//Calculate time
	elapsed_time_no_shared_m = 1000*(end.tv_sec-start.tv_sec) + (float)(end.tv_usec - start.tv_usec)/1000;
	
	printf("elapsed time of kernel funtion that uses shared memory: %.2f ms\n", elapsed_time_use_shared_m);
	printf("elapsed time of kernel funtion that does not use shared memory: %.2f ms\n", elapsed_time_no_shared_m);
	
	//Free device and host memory
	free(h_data);
	cudaFree(d_data);

	return 0;
}

