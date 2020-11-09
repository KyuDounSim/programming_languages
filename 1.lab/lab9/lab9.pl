%list_prefix([], Y).
%list_prefix([A|Atail], [A|Btail]) :- list_prefix(Atail, Btail).
%list_suffix(Atail, Atail).
%list_suffix(Atail, [B|Btail]) :- list_suffix(Atail, Btail).

list_prefix(Elem, List) :- append(Elem, _, List).
list_suffix(Elem, List) :- append(_, Elem, List), Elem \== [], Elem \== List.
list_prefix_suffix(X, Y) :- list_prefix(X,Y); list_suffix(X, Y).
