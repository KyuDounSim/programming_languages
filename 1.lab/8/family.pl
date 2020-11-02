parent('John', 'James').	% fact 1
parent('John', 'Mary'). 	% fact 2
parent('James', 'Judy').	% fact 3

age('John',60). 	% fact 4
age('James',35). 	% fact 5
age('Mary',30). 	% fact 6
age('Judy',9). 		% fact 7

male('John'). 		% fact 8
male('James'). 		% fact 9
female('Mary'). 	% fact 10
female('Judy'). 	% fact 11

sibling(X, Y) :- parent(_1,X), parent(_1,Y), X \== Y. % rule 1
ancestor(X, Y) :- parent(X, Y).                   % rule 2
ancestor(X, Y) :- parent(_1, Y), ancestor(X, _1). % rule 3
older30(X) :- age(X, Y), Y > 30.                     % rule 4
brother(X, Y) :- male(X), sibling(X, Y).          % rule 5
