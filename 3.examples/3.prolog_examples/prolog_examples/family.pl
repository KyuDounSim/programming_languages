mother('Elizabeth', 'Susan').
mother('Elizabeth', 'James').
mother('Elizabeth', 'Joyce').
mother('Susan', 'Kathryn').
mother('Sue', 'Robert').
father('Robert', 'Kathryn').
female('Kathryn').
male('James').
parent(X,Y) :- father(X,Y).
parent(X,Y) :- mother(X,Y).
grantparent(X,Z) :- parent(X,Y), parent(Y,Z).
ancester(X,Y) :- parent(X,Y).
ancester(X,Z) :- parent(X,Y), ancester(Y,Z).
