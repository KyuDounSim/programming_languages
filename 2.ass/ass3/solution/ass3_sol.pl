% Q1
linear_regression(A, B):-
    xs(Xs),
    ys(Ys),
    linear_regression_(Xs, Ys, A, B).

linear_regression_(Xs, Ys, M, C):-
  sums(Xs, Ys, 0, N, 0, S_X, 0, S_Y, 0, S_XY, 0, S_XX),
  M is (S_X * S_Y / N - S_XY) / (S_X * S_X / N - S_XX),
  C is S_Y / N - M * S_X / N.

sums([], [], N, N, S_X, S_X, S_Y, S_Y, S_XY, S_XY, S_XX, S_XX).
sums([X|Xs], [Y|Ys], N0, N, S_X0, S_X, S_Y0, S_Y, S_XY0, S_XY, S_XX0, S_XX):-
  N1 is N0 + 1,
  S_X1 is S_X0 + X,
  S_Y1 is S_Y0 + Y,
  S_XY1 is S_XY0 + X * Y,
  S_XX1 is S_XX0 + X * X,
  sums(Xs, Ys, N1, N, S_X1, S_X, S_Y1, S_Y, S_XY1, S_XY, S_XX1, S_XX).

% Q2

interesting(V) :-
	setof(Distance-Vertex,interesting_vertex(Vertex,Distance), [D-_|_]),
	bagof(D, interesting_vertex(V, D), _).

interesting_vertex(Vertex,Distance) :-
	sparse_vertex(Vertex),
	setof(dense_vertex(Distance,DenseVertex,OutEdge),
		reachable_dense_vertex(Vertex,DenseVertex,Distance,OutEdge),DenseVertices),
	DenseVertices = [dense_vertex(Distance,Vertex1,OutEdge1)|Rest],
	Rest = [dense_vertex(Distance,Vertex2,OutEdge2)|_],
	Vertex1 \== Vertex2,
	OutEdge1 \== OutEdge2.

reachable_dense_vertex(Vertex,DenseVertex,Distance,OutEdge) :-
	connected(Vertex,OutEdge),
	Visited = [Vertex],
	reachable(OutEdge,DenseVertex,Visited,Distance),
	dense_vertex(DenseVertex).

reachable(Vertex,Vertex,Visited,Distance) :- length(Visited,Distance).
reachable(Vertex,TargetVertex,Visited,Distance) :-
	connected(Vertex,Vertex1),
	\+ member(Vertex1,Visited),
	reachable(Vertex1,TargetVertex,[Vertex|Visited],Distance).

dense_vertex(Vertex) :-
	connected(Vertex,VertexA),
	connected(Vertex,VertexB),
	connected(Vertex,VertexC),
	VertexA \== VertexB,
	VertexA \== VertexC,
	VertexB \== VertexC.

sparse_vertex(Vertex) :-
	connected(Vertex,_),
	\+ dense_vertex(Vertex).

connected(From,To) :- edge(From,To).
connected(From,To) :- edge(To,From).

% Q3
ch3(C) :- setof(X, methyl(X), C).
methyl(C) :-
    element(C,carbon),
    atom_elements(C, _, X),
    length(X, L), L =:= 4,
    bonded(C,H1), element(H1,hydrogen),
    bonded(C,H2), element(H2,hydrogen), H1 \== H2,
    bonded(C,H3), element(H3,hydrogen), H3 \== H1,
    H3 \== H2.

% Q4
c6ring(X) :- setof(X, six_membered_carbon_ring(X), X).
six_membered_carbon_ring(X) :-
    element(A1,carbon), bonded(A1,A2),
    element(A2,carbon), bonded(A2,A3), A1 \== A3,
    element(A3,carbon), bonded(A3,A4),
    \+ member(A4,[A1,A2,A3]),
    element(A4,carbon), bonded(A4,A5),
    \+ member(A5,[A1,A2,A3,A4]),
    element(A5,carbon), bonded(A5,A6),
    element(A6,carbon), bonded(A6,A1),
    \+ member(A6,[A1,A2,A3,A4,A5]),
    sort([A1,A2,A3,A4,A5,A6], X).

% Q5
tnt(X) :- setof(X, tnt_(X), X).     
tnt_([A1,[C2,N1, O1, O2],A3,[C4,N2, O3, O4],A5,[C6,N3, O5, O6]]) :-
    element(A1,carbon), bonded(A1,A2),
    element(A2,carbon), bonded(A2,A3), A1 \== A3, \+ bonded(A1, A3),

    bonded(A2, N1), no2_group(N1, O1, O2), 
    element(A3,carbon), bonded(A3,A4),
    \+ member(A4,[A1,A2,A3]),
    \+ bonded(A1, A4),
    \+ bonded(A2, A4),

    element(A4,carbon), bonded(A4,A5),
    \+ member(A5,[A1,A2,A3,A4]),
    \+ bonded(A1, A5),
    \+ bonded(A2, A5),
    \+ bonded(A3, A5),

    bonded(A4, N2), no2_group(N2, O3, O4),
    element(A5,carbon), bonded(A5,A6),
    element(A6,carbon), bonded(A6,A1),
    \+ member(A6,[A1,A2,A3,A4,A5]),
    \+ bonded(A2, A6),
    \+ bonded(A3, A6),
    \+ bonded(A4, A6),
    bonded(A6, N3), no2_group(N3, O5, O6),
    sort([A2, A4], [C2, C4]),
    sort([A2, A6], [C2, C6]),
    sort([A4, A6], [C4, C6]),
    sort([O1, O2], [O1, O2]),
    sort([O3, O4], [O3, O4]), 
    sort([O5, O6], [O5, O6]).

no2_group(N, O1, O2) :-
    element(N, nitrogen),
    atom_elements(N, _, X),
    length(X, L), L =:= 3,
    bonded(N, O1), element(O1, oxygen),
    bonded(N, O2), element(O2, oxygen), O1 \== O2.

bonded(A1,A2) :-
    atom_elements(A1,_,Neighbors),
    member(A2,Neighbors).

element(A1,Element) :- atom_elements(A1,Element,_).
