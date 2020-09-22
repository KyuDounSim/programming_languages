(* SIM, Kyu Doun || kdsim || 2030657*)

fun sumDigits(x: int) =
    if x div 10 = 0 then 
        x
    else 
        x mod 10 + sumDigits(x div 10);

sumDigits(1000);
sumDigits(54321);

fun matchingList([], y ) = [] | matchingList(x, y) =
    if hd(x) = y then
        1::matchingList(tl(x),y)
    else
        0::matchingList(tl(x), y);


fun cumulativeList([], a) = [] | cumulativeList(x, a) =
    if hd(x) = 1 then
        map increment tl(x) 
    else
        hd(x)::cumulativeList(tl(x), a);

fun increment x = x + 1;

fun frequencyPrefixSum([], y) = [] | frequencyPrefixSum(x, y) =
    val a = matchingList(x, y)
    cumulativeList(a, y);
    
frequencyPrefixSum([1. 2. 2. 4. 5]. 2);
frequencyPrefixSum([1, 2, 2, 4, 5], 3);
frequencyPrefixSum([], 2);


fun flatten([]) = [] | flatten(a) = 
    if hd(a) = [] then
        ::[]
    else
        hd(a)::flatten(tl(a));

fun depth([]) = 0 | depth(a) =



fun 
