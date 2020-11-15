/*SIM, Kyu Doun || kdsim || 20306527*/

%Q1
list_sum([], 0).
list_sum([head|tail], sum) :-
    list_sum(tail, remain),
    sum is head + remain.

/*length(?list, ?Int)*/
list_square([], []).
list_square([head|tail], append(head**2, list_square(tail, result), resultant)).

list_pointwise([], [], []).
list_pointwise([head1|tail1], [head2|tail2], append(head1 * head2, list_pointwise(tail1, tail2, resultant), resultant)).

linear_regression(A, B) :-
    A is list_sum(B) * list_sum(list_square(A)) - (list_sum(A) * list_sum(list_pointwise(A, B, resultant))),
    B is length(list_pointwise(A, B)) * list_pointwise(A, B) - list_sum(A) * list_sum(B) / (length(A) * list_sum(list_square(A)) - list_sum(A)**2).
%Q2
interesting(X).

%Q3
ch3(X).

%Q4
c6ring(X).

%Q5
tnt(X).

