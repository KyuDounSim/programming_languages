
num_parent(adam,0).
num_parent(eve, 0).
num_parent(X,2) :- X \= adam, X \= eve.

