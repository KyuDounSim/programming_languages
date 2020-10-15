q(1).
q(2).
r(a).
r(b).
p(X,Y) :- q(X), !, r(Y).
p(3,c).
s(X,Y) :- p(X,Y).
s(4,d).
