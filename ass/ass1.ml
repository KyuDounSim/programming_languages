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


fun cumulativeSum([], y) = [] | cumulativeSum(x) = 
    if hd(x) = 1 then
        1::cumulativeSum(tl(x)) 
    else
        

fun frequencyPrefixSum([], y) = [] | frequencyPrefixSum(x, y) =
    masking = matchingList(x, y)
    
    if hd(masking) = 1 then
         
    else
        frequencyPrefixSum(tl(y), y)


frequencyPrefixSum([1. 2. 2. 4. 5]. 2);
frequencyPrefixSum([1, 2, 2, 4, 5], 3);
frequencyPrefixSum([], 2);
