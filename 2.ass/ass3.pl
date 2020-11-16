/*SIM, Kyu Doun || kdsim || 20306527*/

%Q1
%list_sum([], 0).
%list_sum([head|tail], sum) :-
%    list_sum(tail, remain),
%    sum is head+remain.

/*length(?list, ?Int)*/

xs([1, 2, 3, 4, 5.06, 6]).
ys([1, 3, 2, 6, 7.23, 7]).

list_square([], []).
list_square([H|T], [SQRD_H|SQRD_T]) :-
    SQRD_H is H * H,
    list_square(T, SQRD_T).

list_pointwise([], [], []).
list_pointwise([H1|T1], [H2|T2], [RESULT_H|RESULT_T]) :-
    RESULT_H is H1 * H2,
    list_pointwise(T1, T2, RESULT_T).    

linear_regression([], []).
linear_regression(A, B) :-
   xs(X), ys(Y),
   list_pointwise(X, Y, XY),
   list_square(X, X_SQRD),
   sumlist(X, X_SUM),
   sumlist(X_SQRD, X_SQRD_SUM),
   sumlist(Y, Y_SUM),
   sumlist(XY, XY_SUM),
   length(X_SQRD, X_SQRD_LEN),
   length(XY, XY_LEN),
   B is (Y_SUM * X_SQRD_SUM - X_SUM * XY_SUM) / (X_SQRD_LEN * X_SQRD_SUM - X_SUM * X_SUM),
   A is (XY_LEN * XY_SUM - X_SUM * Y_SUM) / (X_SQRD_LEN * X_SQRD_SUM - X_SUM * X_SUM).


edge('A', 'C').
edge('A', 'B').
edge('A', 'G').
edge('C', 'D').
edge('D', 'E').
edge('E', 'F').
edge('F', 'H').
edge('F', 'G').

%Q2
degree(V, D) :-
    bagof(X, edge(V, X); edge(X, V), Bag),
    length(Bag, D).

sparse(X) :-
    degree(X, X_Sprase),
    X_Sparse =< 2.

dense(X) :-
    degree(X, X_Dense),
    X_Dense > 2.

c2(X) :-
    bagof(A, edge(X, A); edge(A, X), Bag),
    %print(Bag),
    include(dense, Bag, Dense_bag),
    %print(Dense_bag),
    length(Dense_bag, D),
    D >= 2.

path(A, B, []).
path(A, B, Path) :-
    travel(A, B, [A], Q),
    reverse(Q, Path).

travel(A,B,P,[B|P]) :- 
    edge(A,B); edge(B, A).

travel(A,B,Visited,Path) :-
    edge(A, C); edge(C, A),           
    C \== B,
    \+member(C,Visited),
    travel(C,B,[C|Visited],Path).

interesting(X).

%Q3
ch3(X).

%Q4
c6ring(X).

%Q5
tnt(X).

