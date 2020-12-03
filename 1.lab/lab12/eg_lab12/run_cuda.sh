nvcc -DDEBUG -std=c++11 -arch=compute_52 -code=sm_52 prefix_sum.cu -o main
./main in.txt