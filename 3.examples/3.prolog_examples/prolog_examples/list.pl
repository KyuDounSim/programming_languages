cons(X, Y, [X |Y]).
head([X|_],X).
tail([_|Y],Y).
member(X,[X|_]).
member(X,[_|Z]) :- member(X,Z).

