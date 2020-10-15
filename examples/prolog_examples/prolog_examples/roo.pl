roo(X,0) :- writeln('X<3'), X<3.
roo(X,3) :- writeln('3=X<6'), 3 =< X, X<6.
roo(X,6) :- writeln('X>=6'), 6 =< X.

roo1(X,0) :- writeln('X<3'), X<3, !.
roo1(X,3) :- writeln('3=<X<6'), 3 =< X, X<6, !.
roo1(X,6) :- writeln('X>=6'), 6 =< X.


