nvcc -std=c++11 -arch=compute_52 -code=sm_52 main.cu tnt_counting.cu -o tnt_counting
num_block=8
num_thread=512
./tnt_counting data.txt $num_block $num_thread