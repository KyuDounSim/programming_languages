my_length(L,_) :- assert(counter(0)), member(_,L), counter(M), M1 is M+1, 
		  retract(counter(M)), assert(counter(M1)), fail.

my_length(_,N) :- counter(N), retract(counter(N)).
