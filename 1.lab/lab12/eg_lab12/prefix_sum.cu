/*
 * Do not change this file
 */

#include <iostream>
#include <fstream>
#include <cassert>
#include <cstring>
#include <string>
#include <chrono>
#include <cstdlib>
#include <ctime>
#define MAX_LENGTH 1024

/**
 * Read file, save edges to array (x_x) and 
 * record the size of each type of edge array (x_x_count).
 */
namespace utils {
	int target;
	int len;
	int *list;

	int read_file(std::string filename) {
		std::ifstream inputf(filename, std::ifstream::in);
		len = 0;
		list = (int*)malloc(sizeof(int) * MAX_LENGTH);
		if(inputf) {
			while (!inputf.eof()){
				inputf >> list[len];
				len++;
			}
		} else {
			return -1;
		}
		inputf.close();
		return 0;
	}

	int write_file(std::string filename, int *out){
		std::ofstream outputf(filename, std::ofstream::out);
		if(outputf.is_open()){
			for(int i = 0; i < len; i++){
				outputf << out[i] << std::endl;
			}
		} else {
			return -1;
		}
		outputf.close();
		return 0;
	}
}

/**
 * Global function: prefix sum
 * d_in:              original array
 * d_out:             prefix sum array (need to be allocated before)
 * numElems:          the sum of the array.
 * target_n:	      the target to check frequency.
 */
__global__ void prefix_sum_kernel(int *d_out, int *d_in, int numElems) {
	unsigned int d_hist_idx = blockDim.x * blockIdx.x + threadIdx.x;

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

__global__ void improved_prefix_sum_kernel(int *out, int *in, int n)
{
	__shared__ int temp[2049];

	int threadId = threadIdx.x;
	int offset = 1;

	//load input into shared memory
	temp[2 * threadId] = in[2 * threadId];
	temp[2 * threadId + 1] = in[2 * threadId + 1];
	__syncthreads();

	for(int d = n/2; d > 0; d /= 2) // build sum in place up the tree
	{
		__syncthreads();
		if(threadId < d)
		{
			int ai = offset * (2 * threadId + 1) - 1;
			int bi = offset * (2 * threadId + 2) - 1;
			temp[bi] += temp[ai];
		}
		offset *= 2;
	}

	if(threadId == 0) // clear the last element
		temp[n-1] = 0;

	for(int d = 1; d < n; d *= 2)
	{
		offset /= 2;
		__syncthreads();

		if(threadId < d)
		{
			int ai = offset * (2 * threadId + 1) - 1;
			int bi = offset * (2 * threadId + 2) - 1;
			int t = temp[ai];
			temp[ai] = temp[bi];
			temp[bi] += t;
		}
	}
	__syncthreads();

	out[2 * threadId] = temp[2 * threadId + 1];
	out[2 * threadId + 1] = temp[2 * threadId + 2];
	if (threadId == 0) {
		out[n - 1] = out[n - 2] + in[n - 1];
	}
}


int main(int argc, char **argv) {
    assert(argc == 2 && "Input format error!");
    std::string filename = argv[1];
    assert(utils::read_file(
        	filename
    		) == 0
		);
	int numElems = utils::len;
	int *d_in;
	int *d_out;

	cudaMalloc((void**)&d_in, sizeof(int) * numElems);
	cudaMalloc((void**)&d_out, sizeof(int) * numElems);

	int *h_out = (int*)malloc(sizeof(int) * numElems);

	cudaMemcpy(d_in, utils::list, sizeof(int) * numElems, cudaMemcpyHostToDevice);

	dim3 grid(1);
	dim3 block(1024);

    auto t_start = std::chrono::high_resolution_clock::now();

    cudaEvent_t cuda_start, cuda_end;
    cudaEventCreate(&cuda_start);
    cudaEventCreate(&cuda_end);
    float naive_kernel_time;
    float improved_kernel_time;
    cudaEventRecord(cuda_start);

	prefix_sum_kernel<<<grid, block>>>(
			d_out,
			d_in,
			numElems);

    cudaEventRecord(cuda_end);

    cudaEventSynchronize(cuda_start);
    cudaEventSynchronize(cuda_end);
    cudaEventElapsedTime(&naive_kernel_time, cuda_start, cuda_end);
	cudaDeviceSynchronize();
	cudaMemcpy(h_out, d_out, sizeof(int) * numElems, cudaMemcpyDeviceToHost);
	assert(
			utils::write_file(
					"naive_out.txt",
					h_out
			) == 0
	);

	cudaEventRecord(cuda_start);

	improved_prefix_sum_kernel<<<grid, block>>>(
			d_out,
			d_in,
			numElems
			);

	cudaEventRecord(cuda_end);

	cudaEventSynchronize(cuda_start);
	cudaEventSynchronize(cuda_end);
	cudaEventElapsedTime(&improved_kernel_time, cuda_start, cuda_end);
	cudaDeviceSynchronize();

	cudaMemcpy(h_out, d_out, sizeof(int) * numElems, cudaMemcpyDeviceToHost);
	assert(
			utils::write_file(
					"improved_out.txt",
					h_out
			) == 0
	);

    auto t_end = std::chrono::high_resolution_clock::now();


	fprintf(stderr, "Naive    prefix_sum Time: %.9lf s\n", naive_kernel_time / pow(10, 3));
	fprintf(stderr, "Improved Prefix_sum Time: %.9lf s\n", improved_kernel_time / pow(10, 3));

	cudaFree(d_out);
	cudaFree(d_in);
	free(h_out);
    return 0;
}