all: vectorAdd_seq vectorAdd_gpu warp_example shared_memory_example demo2

vectorAdd_seq : vectorAdd.cpp 
	g++ vectorAdd.cpp -o vectorAdd_seq -O3 

vectorAdd_gpu: vectorAdd.cu
	nvcc vectorAdd.cu -o vectorAdd_gpu 

warp_example: warp_example.cu
	nvcc warp_example.cu -o warp_example 

shared_memory_example : shared_memory_example.cu
	nvcc shared_memory_example.cu -o shared_memory_example

demo2: demo2.cu
	nvcc demo2.cu -o demo2

.PHONY : clean

clean :
	-rm -f vectorAdd_seq vectorAdd_gpu warp_example shared_memory_example demo2

