(* SIM, Kyu Doun || kdsim || 20306527*)

fun sumDigits(x: int) =
    if x div 10 = 0 then 
        x
    else 
        x mod 10 + sumDigits(x div 10);

(*sumDigits(0);
sumDigits(1000);
sumDigits(54321);*)

fun incrementList([], a) = [] | incrementList(n, a) =
    (hd(n) + a)::incrementList(tl(n), a);

fun matchingList([], y ) = [] | matchingList(x, y) =
    if hd(x) = y then
        1::matchingList(tl(x), y)
    else
        0::matchingList(tl(x), y);

fun cumulSum([]) = [] | cumulSum(n) = 
    hd(n)::incrementList(cumulSum(tl(n)), hd(n))
 
fun frequencyPrefixSum([], y) = [] | frequencyPrefixSum(lst:int list, n:int) =
    cumulSum(matchingList(lst, n));
 
(*frequencyPrefixSum([1, 2, 2, 4, 5], 2);
frequencyPrefixSum([1, 2, 2, 4, 5], 3);
frequencyPrefixSum([2, 1, 1, 1], 2);
frequencyPrefixSum([], 2);*)


datatype 'a llist = LList of 'a llist list | Elem of 'a;

(*Elem(1);
LList [];
LList ([Elem(1), LList([Elem(2), LList([Elem 1, Elem(3)]), Elem(4)])]);

val a = LList([Elem(1), Elem(2)]);*)

fun flatten(LList([])) = [] | flatten (Elem(x)) = x::[] | flatten(LList(head::tail)) = flatten(head)@flatten(LList(tail));

(*flatten(Elem(3));
flatten(LList([]));
flatten(LList([Elem(1), LList([Elem(2), LList([]), LList([]), Elem(3)]), Elem(4)]));*)


fun depth(Elem(x)) = 0 | depth(LList([])) = 1 | depth(LList(head::tail)) = depth(head) + depth(LList(tail));

(*depth(Elem(1));
depth(LList([]));
depth(LList([Elem(1), LList([Elem(2), LList([]), Elem(3)]), Elem(4)]));*)


fun equal(Elem a, Elem b) = (a = b) | equal(Elem _, LList _) = false | equal(LList _, Elem _) = false | equal(LList([]), LList([])) = true | equal(LList([]), LList(lst)) = false | equal(LList(lst), LList([])) = false | equal(LList(a_hd::a_tl), LList(b_hd::b_tl)) = if (a_hd = b_hd) then equal(LList(a_tl), LList(b_tl)) else false;

(*
val test_1 = Elem(3);
val test_2 = Elem(9);
equal(test_1, test_2);

val test_1 = Elem(3+6);
val test_2 = Elem(9);
equal(test_1, test_2);

val test_3 = LList([Elem(#"1")]);
val test_4 = LList([Elem(#"1")]);
equal(test_3, test_4);

val test_5 = LList([Elem(1), LList([Elem(2), LList([Elem(5), Elem(6)]), Elem(3)]), Elem(4)]);
val test_6 = LList([Elem(1), LList([Elem(2), LList([Elem(5), LList([Elem(6)])]), Elem(3)]), Elem(4)]);
equal(test_5, test_6);*)
