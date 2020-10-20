qSort([],[]).
qSort([X|X1], Result) :-
	split(X,X1, Less, NotLess),
	qSort(Less, SortLess),
	qSort(NotLess, SortNotLess),
	append(SortLess, [X|SortNotLess], Result).

