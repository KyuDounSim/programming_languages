for(int i = tid; i < 2048; i += num_threads) {
	for(int j = 0; j < 2048; j += 1) {
		if(d_A[i] == d_B[j]) {
			d_C[tid]++;
		}
	} 
}

// OR

for (int i = tid; i < 2048 * 2048; i += num_threads) {
	if (d_A[i / 2048] == d_B[i % 2048]) {
		d_C[tid]++;
	}
}
