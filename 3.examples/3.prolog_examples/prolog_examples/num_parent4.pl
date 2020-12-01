
num_parent(X,0) :- !, adam_eve(X).
num_parent(X,2) :- \+ adam_eve(X).
adam_eve(adam).
adam_eve(eve).

