/*SIM, Kyu Doun || kdsim || 20306527*/

%Q1
%list_sum([], 0).
%list_sum([head|tail], sum) :-
%    list_sum(tail, remain),
%    sum is head+remain.

/*length(?list, ?Int)*/

xs([1, 2, 3, 4, 5.06, 6]).
ys([1, 3, 2, 6, 7.23, 7]).

%list_square([], []).
list_square([H|T], [SQRD_H|SQRD_T]) :-
    SQRD_H is H * H,
    list_square(T, SQRD_T).

list_pointwise([], [], []).
list_pointwise([H1|T1], [H2|T2], [RESULT_H|RESULT_T]) :-
    RESULT_H is H1 * H2,
    list_pointwise(T1, T2, RESULT_T).    

%linear_regression([], []).
/*linear_regression(A, B) :-
   list_pointwise(A, B, AB),
   list_square(A, A_SQRD),
   sumlist(A, A_SUM),
   sumlist(A_SQRD, A_SQRD_SUM),
   sumlist(B, B_SUM),
   sumlist(AB, AB_SUM),
   length(A_SQRD, A_SQRD_LEN),
   length(AB, AB_LEN),
   A is (B_SUM * A_SQRD_SUM - A_SUM * AB_SUM) / (A_SQRD_LEN * A_SQRD_SUM - A_SUM * A_SUM),
   B is (AB_LEN * AB_SUM - A_SUM * B_SUM) / (A_SQRD_LEN * A_SQRD_SUM - A_SUM * A_SUM).
*/

linear_regression(A, B) :-
   list_pointwise(xs, ys, XY),
   list_square(xs, X_SQRD),
   sumlist(xs, X_SUM),
   sumlist(X_SQRD, X_SQRD_SUM),
   sumlist(ys, Y_SUM),
   sumlist(XY, XY_SUM),
   length(X_SQRD, X_SQRD_LEN),
   length(XY, XY_LEN),
   A is (Y_SUM * X_SQRD_SUM - X_SUM * XY_SUM) / (X_SQRD_LEN * X_SQRD_SUM - X_SUM * X_SUM),
   B is (XY_LEN * XY_SUM - X_SUM * Y_SUM) / (X_SQRD_LEN * X_SQRD_SUM - X_SUM * X_SUM).

%Q2
interesting(X).

%Q3
ch3(X).

%Q4
c6ring(X).

%Q5
tnt(X).

