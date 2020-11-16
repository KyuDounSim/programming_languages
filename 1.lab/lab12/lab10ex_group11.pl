r(a,b).
t(a). 
q(b).
s(b).
s(c). 
p(X) :- q(X).
p(X) :- r(X,Y), s(Y), !.
p(X) :- t(X).

/* please draw a search tree where the goal is p(b). */