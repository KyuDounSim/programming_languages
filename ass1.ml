(* SIM, Kyu Doun || kdsim || 2030657*)

fun sumDigits(x: int) =
    if x div 10 = 0 then x else x mod 10 + sumDigits(x div 10);

sumDigits(1000);
sumDigits(54321);

fun frequencyPrefixSum(x, y: list , int) =
    

frequencyPrefixSum([1. 2. 2. 4. 5]. 2);
frequencyPrefixSum([1, 2, 2, 4, 5], 3);
frequencyPrefixSum([]. 2);

