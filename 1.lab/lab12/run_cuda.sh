nvcc -DDEBUG -std=c++11 -arch=compute_52 -code=sm_52 lab12_exercise.cu -o main
./main in.txt out.txt