/*SIM, Kyu Doun || kdsim || 20306527*/

%Q1
%list_sum([], 0).
%list_sum([head|tail], sum) :-
%    list_sum(tail, remain),
%    sum is head+remain.

/*length(?list, ?Int)*/
%xs([1, 2, 3, 4, 5.06, 6]).
%ys([1, 3, 2, 6, 7.23, 7]).

list_square([], []).
list_square([H|T], [SQRD_H|SQRD_T]) :-
    SQRD_H is H * H,
    list_square(T, SQRD_T).

list_pointwise([], [], []).
list_pointwise([H1|T1], [H2|T2], [RESULT_H|RESULT_T]) :-
    RESULT_H is H1 * H2,
    list_pointwise(T1, T2, RESULT_T).    

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

/*
edge('A', 'C').
edge('A', 'B').
edge('A', 'G').
edge('C', 'D').
edge('D', 'E').
edge('E', 'F').
edge('F', 'H').
edge('F', 'G').
edge('D', 'Z').
*/

%Q2
degree(V, D) :-
    bagof(X, edge(V, X); edge(X, V), Bag),
    length(Bag, D).

sparse(X) :-
    degree(X, X_degree),
    X_degree =< 2.

dense(X) :-
    degree(X, X_degree),
    X_degree > 2.

c2_dense(X) :-
    bagof(A, edge(X, A); edge(A, X), Bag),
    %print(Bag),
    include(dense, Bag, Dense_bag),
    %print(Dense_bag),
    length(Dense_bag, D),
    D >= 2.

path(A, B, Path) :-
    %A \== B,
    path(A, B, [A, B], P1),
    Path = [A|P1].

path(A,B, _, Path) :- 
    (edge(A,B); edge(B, A)),
    Path = [B].

path(A,B,Visited,Path) :-
    (edge(A, C); edge(C, A)),
    %B \== C,          
    \+ member(C, Visited),
    path(C, B, [C|Visited], P1),
    Path = [C|P1].

shortest_path(A, B, Shortest_paths) :-
    aggregate(min(Len, All_paths), (path(A, B, All_paths), length(All_paths, Len)), min(Len, Shortest_paths)).
    %print(LEN).
    %include(length, All_paths, All_paths_len),
    %print(All_paths_len).

shortest_2_dense(A, Length_dense) :-
    sparse(A),
    findall(X, dense(X), All_dense_nodes),
    maplist(shortest_path(A), All_dense_nodes, All_dense_paths),
    maplist(length, All_dense_paths, All_densepath_len),
    msort(All_densepath_len, All_Dense_sort),
    [First | Tail] = All_Dense_sort,
    [Second | _] = Tail,
    %bagof(First, (First =:= Second), Length_dense).
    First =:= Second, Length_dense is First.

interesting(X) :-
    findall(Length_list, shortest_2_dense(_, Length_list), Node_len),
    min_list(Node_len, MIN),
    shortest_2_dense(X, Node_len_elem),
    Node_len_elem == MIN.
    %findall(A, shortest_2_dense(A, Length_list), X),
    %findall(Length_list, shortest_2_dense(A, Length_list), Node_len),
    %min_list(Node_len, MIN).
    % Correct output format but not the output content
    %aggregate(min(Node_len, Node_list), (shortest_2_dense(Node_list, Node_len)) , min(Len, X)).

%bagof(First, ([First, Second, _] = All_densepath_sorted, First =:= Second), First_1).
    %maplist(min_list, First_1, Minimum_length),
    %maplist([First, Second, _], All_densepath_sorted, Final),
    %maplist(First, (First =:= Second), All_final),
    %print(Minimum_length), print(A).
    %maplist(First, (First =:= Second), Length_dense),
    %print(Result). %print(All_dense_paths).
%findall(Each_len, length(Paths, Each_len), Len_list),
%maplist(length,shorets_path(),).
/* compare_length(A, Dense_path_len) :- sparse(A),
 * shortest_2_dense
    maplist(),shortest_path(A, Dense_node, X_dense_path),
    Dense_path = [X_dense_path],
    maplist(length, Dense_path, Dense_path_len). */

/*
atom_elements(h1,hydrogen,[c1]).
atom_elements(h2,hydrogen,[c2]).
atom_elements(h4,hydrogen,[c4]).
atom_elements(h5,hydrogen,[c5]).
atom_elements(h6,hydrogen,[c6]).
atom_elements(h7,hydrogen,[c7]).
atom_elements(h8,hydrogen,[c7]).
atom_elements(h9,hydrogen,[c7]).
atom_elements(c1,carbon,[c2,c6,h1]).
atom_elements(c2,carbon,[c1,c3,h2]).
atom_elements(c3,carbon,[c2,c7,c4]).
atom_elements(c4,carbon,[c3,c5,h4]).
atom_elements(c5,carbon,[c4,c6,h5]).
atom_elements(c6,carbon,[c1,c5,h6]).
atom_elements(c7,carbon,[c3,h7,h8,h9]).
*/

/*
 * atom_elements(h11, hydrogen, [c8]).
atom_elements(h12, hydrogen, [c8]).
atom_elements(h13, hydrogen, [c8]).
atom_elements(h14, hydrogen, [c9]).
atom_elements(h15, hydrogen, [c9]).
atom_elements(h16, hydrogen, [c9]).
atom_elements(c8, carbon, [c9, h11, h12, h13]).
atom_elements(c9, carbon, [c8, h14, h15, h16]).
*/


%Q3
c_cnt([], 0).
c_cnt([H|T], Count) :-
    atom_elements(H, carbon, _),
    c_cnt(T, Next),
    Count is Next + 1.

c_cnt([H1|T], Count) :-
    \+ atom_elements(H1, carbon, _),
    c_cnt(T, Next),
    Count is Next.

h_cnt([], 0).
h_cnt([H|T], Count) :-
    atom_elements(H, hydrogen, _),
    h_cnt(T, Next),
    Count is Next + 1.

h_cnt([H1|T], Count) :-
   \+ atom_elements(H1, hydrogen, _),
   h_cnt(T, Next),
   Count is Next.
 
ch3(X) :-
     findall(Name, (atom_elements(Name, carbon, List), h_cnt(List, H_cnt), H_cnt =:= 3), X).

%Q4
contains(A, [A|_]).
contains(A, [A1|R]) :- A \== A1,contains(A, R).

isNeighbor(A, B) :-
    atom_elements(B, _, List_B),
    contains(A, List_B).

chem_path(A, B, Path) :-
    %A \== B,
    chem_path(A, B, [A, B], P1),
    Path = [A|P1].

chem_path(A,B, _, Path) :- 
    isNeighbor(A, B),
    Path = [B].

chem_path(A,B,Visited,Path) :-
    (isNeighbor(A, C)),
    %B \== C,          
    \+ member(C, Visited),
    chem_path(C, B, [C|Visited], P1),
    Path = [C|P1].

chem_shortest_path(A, B, Shortest_paths) :-
    aggregate(min(Len, All_paths), (chem_path(A, B, All_paths), length(All_paths, Len)), min(Len, Shortest_paths)).


c6ring_pre2(X) :- 
    setof(C, (atom_elements(C_start, carbon, _), chem_path(C_start, C_start, Paths), length(Paths, Paths_len), Paths_len =:= 7, [_ | C] = Paths), All_path),
    member(All_path_elems, All_path),
    setof(Final, (sort(All_path_elems, Second), member(Final, Second)), Path_sorted),
    msort(Path_sorted, X).

c6ring(X) :-
    findall(A, c6ring_pre2(A), Almost),
    sort(Almost, X).
    %member(X, Almost_2).

%Q5

atom_elements(c1,carbon,[c2,c6,c7]).
atom_elements(c2,carbon,[c1,c3,n1]).
atom_elements(c3,carbon,[c2,c4,c8]).
atom_elements(c4,carbon,[c3,c5,n2]).
atom_elements(c5,carbon,[c4,c6,c14]).
atom_elements(c6,carbon,[c5,c1,n3]).
atom_elements(c7,carbon,[c1,h1,h2,h3]).
atom_elements(c8,carbon,[c3,c9,c13]).
atom_elements(c9,carbon,[c8,c10,n4]).
atom_elements(c10,carbon,[c9,c11,n5]).
atom_elements(c11,carbon,[c10,c12,h4]).
atom_elements(c12,carbon,[c11,c13,h5]).
atom_elements(c13,carbon,[c12,c8,n6]).
atom_elements(c14,carbon,[c5,c15,c19]).
atom_elements(c15,carbon,[c14,c16,n7]).
atom_elements(c16,carbon,[c15,c17,h6]).
atom_elements(c17,carbon,[c16,c18,n8]).
atom_elements(c18,carbon,[c17,c19,h7]).
atom_elements(c19,carbon,[c18,c14,n9]).

atom_elements(h1,hydrogen,[c7]).
atom_elements(h2,hydrogen,[c7]).
atom_elements(h3,hydrogen,[c7]).
atom_elements(h4,hydrogen,[c10]).
atom_elements(h5,hydrogen,[c12]).
atom_elements(h6,hydrogen,[c16]).
atom_elements(h7,hydrogen,[c18]).
atom_elements(h8,hydrogen,[n9]).
atom_elements(h9,hydrogen,[n9]).

atom_elements(n1,nitrogen,[c2,o1,o2]).
atom_elements(n2,nitrogen,[c4,o3,o4]).
atom_elements(n3,nitrogen,[c6,o5,o6]).
atom_elements(n4,nitrogen,[c9,o7,o8]).
atom_elements(n5,nitrogen,[c11,o9,o10]).
atom_elements(n6,nitrogen,[c13,o11,o12]).
atom_elements(n7,nitrogen,[c15,o13,o14]).
atom_elements(n8,nitrogen,[c17,o15,o16]).
atom_elements(n9,nitrogen,[c19,o17,h8,h9]).

atom_elements(o1,oxygen,[n1]).
atom_elements(o2,oxygen,[n1]).
atom_elements(o3,oxygen,[n2]).
atom_elements(o4,oxygen,[n2]).
atom_elements(o5,oxygen,[n3]).
atom_elements(o6,oxygen,[n3]).
atom_elements(o7,oxygen,[n4]).
atom_elements(o8,oxygen,[n4]).
atom_elements(o9,oxygen,[n5]).
atom_elements(o10,oxygen,[n5]).
atom_elements(o11,oxygen,[n6]).
atom_elements(o12,oxygen,[n6]).
atom_elements(o13,oxygen,[n7]).
atom_elements(o14,oxygen,[n7]).
atom_elements(o15,oxygen,[n8]).
atom_elements(o16,oxygen,[n8]).
atom_elements(o17,oxygen,[n9]).

n_cnt([], 0).
n_cnt([H|T], Count) :-
    atom_elements(H, nitrogen, _),
    n_cnt(T, Next),
    Count is Next + 1.

n_cnt([H1|T], Count) :-
    \+ atom_elements(H1, nitrogen, _),
    n_cnt(T, Next),
    Count is Next.

o_cnt([], 0).
o_cnt([H|T], Count) :-
    atom_elements(H, oxygen, _),
    o_cnt(T, Next),
    Count is Next + 1.
o_cnt([H1|T], Count) :-
    \+ atom_elements(H1, oxygen, _),
    o_cnt(T, Next),
    Count is Next.

extract_n([], []).
extract_n([H|T], Nitro_list) :-
    atom_elements(H, nitrogen, _),
    extract_n(T, Next),
    Nitro_list = [H | Next].

extract_n([H1|T], Nitro_list) :-
    \+ atom_elements(H1, nitrogen, _),
    extract_n(T, Next),
    Nitro_list = Next.

extract_c([], []).
extract_c([H|T], Carbon_list) :-
    atom_elements(H, carbon, _),
    extract_c(T, Next),
    Carbon_list = [H | Next].

extract_c([H1|T], Carbon_list) :-
    \+ atom_elements(H1, carbon, _),
    extract_c(T, Next),
    Carbon_list = Next.

no2(X) :-
     findall(Name, (atom_elements(Name, nitrogen, List), length(List, D), D =:= 3, c_cnt(List, C_cnt), o_cnt(List, O_cnt), C_cnt =:= 1, O_cnt =:= 2), X).

/*
c2n(X) :-
    findall(Name, (atom_elements(Name, carbon, List), length(List, D), D =:=3, carbon_count(List, C_cnt), nitrogen_count(List, N_cnt), C_cnt =:= 2, N_cnt =:=1), X).

cno2(X) :-
    c2n(C2n_list),
    maplist(atom_elements(), C2n_list, Lists),   
    %bagof(Name, (atom_elements(C2n_list, _, Name)), Lists),
    print(Lists).
*/

/*
member_append(Element, [], []).
member_append(Element, [Element|Rest], Result) :- 
    member_append(Element, Rest, Next),
    Result = [Element | Next].    

member_append(Element, [E1|Rest], Result):-
    member_append(Rest, Reulst1),    
    Result = Next.
 */
    
tnt_pre_filter(Filtered_c, Ring) :-
    c6ring(C6ring_raw), member(C6_mem, C6ring_raw), Ring = C6_mem,
    no2(No2_list),
    maplist(atom_elements, No2_list, _, No2_elem_con_list),
    maplist(extract_c, No2_elem_con_list, No2_c),
    flatten(No2_c, No2_c_flat),
    %member(No2_c_e, No2_c_flat), print(No2_c_e),
    %print(C6_mem), member(No2_c_e, C6_mem).
    bagof(No2_ce, (member(No2_ce, No2_c_flat), member(No2_ce, C6_mem)), Filtered_c), length(Filtered_c, D), D =:=3.

tnt_pre_length(X, Ring) :-
    tnt_pre_filter(Filtered_c, Ring),
    findall(Elem1, (member(Elem1, Filtered_c), member(Elem2, Filtered_c), Elem1 \== Elem2, chem_shortest_path(Elem1, Elem2, A1), length(A1, A1_len), A1_len =:= 3), Elems_raw),
    sort(Elems_raw, Elems), sort(Filtered_c, F_c_sort),
    Elems == F_c_sort,
    X = Elems.
    %bagof(Nochange,(member(Nochange,C6ring), member(Elem, Elems), atom_elements(Elem, _, Elem_con), extract_n(Elem_con, N_ext), member(N_ext_mem, N_ext), atom_elements(N_ext_mem, _, AAA), Input_raw = [AAA, N_ext], flatten(Input_raw, Input_flat), sort(Input_flat, Elem)), X).

tnt_pre_2(Ring, Filtered_2, Compound):-
    tnt_pre_length(Filtered, C6ring), 
    Ring = C6ring, Filtered_2 = Filtered,
    bagof(All, (member(All, C6ring)), X),
    member(Match, X), member(Match, Filtered),
    atom_elements(Match, _, Special_con),
    extract_n(Special_con, Special_n),
    member(N_elem, Special_n), atom_elements(N_elem, _, AA),
    Input_raw = [Special_n, AA], flatten(Input_raw, Input_flat),
    sort(Input_flat, Compound).
    %member(S_elem, Speical_n),
    %print(Special_n_elem),
    %atom_elements(S_elem, _, N_con).
    %Input_raw = [Special_n_elem, N_con],
    %flatten(Input_raw, Input_flat),
    %Match = Input_flat.

tnt_pre(X, Remains) :-
    %bagof(A, tnt_pre_2(Ring, Filtered, A), Result),
    tnt_pre_2(Ring, Filtered, A),
    %bagof(Result, tnt_pre_2(Ring, Filtered, Result), Combined),
    subtract(Ring, Filtered, Remains),
    %print(Ring), print(Filtered), print(Remains),
    X = A.

tnt_fin(X) :-
    setof(A, tnt_pre(A, Remainder), A_pre),
    %setof(B, tnt_pre(_, B), Remainder),
    %tnt_pre(_, Remainder), 
    sort(A_pre, A_fin), sort(Remainder, Rems),
    %print(A_fin), print(Rems),
    %flatten(Rems, R), 
    append(A_fin, Rems, X).

tnt(X) :-
    setof(A, tnt_fin(A), A_bag), sort(A_bag, X).


tnt_trash(X) :-
    c6ring(C6ring), no2(No2_list),
    [[A, B, C, D, E, F]] = C6ring,
    (
        (
        atom_elements(A, _, A_list), c_cnt(A_list, A_c_cnt),
        n_cnt(A_list, A_n_cnt), A_c_cnt =:= 2, A_n_cnt =:= 1,
        extract_n(A_list, A_n_name), nth0(0, A_n_name, A_n_elem),
        member(A_n_elem, No2_list), atom_elements(A_n_elem, _, A_o2),
        A_no2 = [A , A_n_elem, A_o2], flatten(A_no2, A_no2_flat),
        sort(A_no2_flat, A_no2_fin),
 
        atom_elements(C, _, C_list), c_cnt(C_list, C_c_cnt),
        n_cnt(C_list, C_n_cnt), C_c_cnt =:= 2, C_n_cnt =:= 1,
        extract_n(C_list, C_n_name), nth0(0, C_n_name, C_n_elem),
        member(C_n_elem, No2_list), atom_elements(C_n_elem, _, C_o2),
        C_no2 = [C, C_n_elem, C_o2], flatten(C_no2, C_no2_flat),
        sort(C_no2_flat, C_no2_fin),          
    
        atom_elements(E, _, E_list), c_cnt(E_list, E_c_cnt),
        n_cnt(E_list, E_n_cnt), E_c_cnt =:= 2, E_n_cnt =:= 1,
        extract_n(E_list, E_n_name), nth0(0, E_n_name, E_n_elem),
        member(E_n_elem, No2_list), atom_elements(E_n_elem, _, E_o2),
        E_no2 = [E, E_n_elem, E_o2], flatten(E_no2, E_no2_flat),
        sort(E_no2_flat, E_no2_fin), 
        X = [A_no2_fin, B, C_no2_fin, D, E_no2_fin, F]
        ); 
        
        (
        atom_elements(B, _, B_list), c_cnt(B_list, B_c_cnt),
        n_cnt(B_list, B_n_cnt), B_c_cnt =:= 2, B_n_cnt =:= 1,
        extract_n(B_list, B_n_name), nth0(0, B_n_name, B_n_elem),
        member(B_n_elem, No2_list), atom_elements(B_n_elem, _, B_o2),
        B_no2 = [B , B_n_elem, B_o2], flatten(B_no2, B_no2_flat),
        sort(B_no2_flat, B_no2_fin),
 
        atom_elements(D, _, D_list), c_cnt(D_list, D_c_cnt),
        n_cnt(D_list, D_n_cnt), D_c_cnt =:= 2, D_n_cnt =:= 1,
        extract_n(D_list, D_n_name), nth0(0, D_n_name, D_n_elem),
        member(D_n_elem, No2_list), atom_elements(D_n_elem, _, D_o2),
        D_no2 = [D, D_n_elem, D_o2], flatten(D_no2, D_no2_flat),
        sort(D_no2_flat, D_no2_fin),          
    
        atom_elements(F, _, F_list), c_cnt(F_list, F_c_cnt),
        n_cnt(F_list, F_n_cnt), F_c_cnt =:= 2, F_n_cnt =:= 1,
        extract_n(F_list, F_n_name), nth0(0, F_n_name, F_n_elem),
        member(F_n_elem, No2_list), atom_elements(F_n_elem, _, F_o2),
        F_no2 = [F, F_n_elem, F_o2], flatten(F_no2, F_no2_flat),
        sort(F_no2_flat, F_no2_fin), 
        X = [A, B_no2_fin, C, D_no2_fin, E, F_no2_fin]
        )
    ).

tnt_trash_1(X) :-
    findall(A, tnt_pre(A), Pre_X),
    sort(Pre_X, X).
