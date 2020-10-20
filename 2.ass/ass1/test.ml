(*PART ONE*)
(*1*)

val test_1 = 12345;
sumDigits(test_1);

val test_2 = 0;
sumDigits(test_2);

val test_3 = 9;
sumDigits(test_3);

val test_4 = 1000;
sumDigits(test_4);

(*2*)

frequencyPrefixSum ([1, 2, 2, 4, 5], 5);
frequencyPrefixSum ([1, 2, 2, 4, 5], 2);
frequencyPrefixSum ([1, 2, 2, 4, 5], 3);
frequencyPrefixSum ([], 2);
frequencyPrefixSum ([3, 3, 3, 3, 3, 3, 3, 3, 3], 3);

(*3*)

val test_1 = LList([]);
flatten(test_1);

val test_2 = Elem(3);
flatten(test_2);

val test_3 = LList([Elem(1), LList([Elem(2), LList([]), Elem(3)]), Elem(4)]);
flatten(test_3);

val test_4 = LList([LList([LList([])])]);
flatten(test_4);

val test_5 = LList([LList([Elem(2), LList([]), Elem(3)]), Elem(4), Elem(1)]);
flatten(test_5);

(*4*)
val test_1 = LList([]);
depth(test_1);

val test_2 = Elem(3);
depth(test_2);

val test_3 = LList([Elem(1), LList([Elem(2), LList([LList([Elem(5)])]), Elem(3)]), Elem(4)]);
depth(test_3);

val test_4 = LList([LList([LList([])])]);
depth(test_4);

(*5*)
val test_1 = Elem(3+6);
val test_2 = Elem(9);
equal(test_1, test_2);

val test_3 = LList([Elem(3)]);
val test_4 = LList([Elem(9)]);
equal(test_3, test_4);

val test_5 = LList([Elem(1), LList([Elem(2), LList([Elem(5), Elem(6)]), Elem(3)]), Elem(4)]);
val test_6 = LList([Elem(1), LList([Elem(2), LList([Elem(5), LList([Elem(6)])]), Elem(3)]), Elem(4)]);

equal(test_5, test_6);

val test_7 = LList([LList([Elem(2), LList([Elem(5), Elem(6)]), Elem(3)]), Elem(4), LList([Elem(1)])]);
val test_8 = LList([LList([Elem(2), LList([Elem(5), LList([Elem(6)])]), Elem(3)]), Elem(4), LList([Elem(1)])]); 
equal(test_7, test_8);

val test_9 = LList([LList([Elem(2), LList([Elem(5), Elem(6)]), Elem(3)]), Elem(4), LList([Elem(1)])]);
val test_10 = LList([LList([Elem(2), LList([Elem(5), Elem(6)]), Elem(3)]), Elem(4), LList([Elem(1)])]); 
equal(test_9, test_10);

val test_11 = LList([LList([Elem(2), LList([Elem(5), Elem(6)]), Elem(3)]), Elem(4)]);
val test_12 = LList([LList([Elem(2), LList([Elem(5), Elem(6)]), Elem(3)]), Elem(4), LList([Elem(1)])]); 
equal(test_11, test_12);

val test_11 = LList([LList([Elem(2), LList([Elem(5), Elem(6)]), Elem(3)]), Elem(4)]);
val test_12 = LList([LList([Elem(2), LList([Elem(5), Elem(6)]), Elem(3)])]); 
equal(test_11, test_12);
