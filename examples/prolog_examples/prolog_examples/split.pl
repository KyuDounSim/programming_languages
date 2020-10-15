split(X,[],[],[]).
split(X, [Y | Y1], [Y |Less], NotLess) :- Y<X, split(X, Y1, Less, NotLess).
split(X, [Y | Y1], Less, [Y | NotLess]) :- Y>=X, split(X, Y1, Less, NotLess).
