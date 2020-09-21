fun GreaterFilter([], a) = [] | GreaterFilter((head::tail), a) =
    if (a < head) then
        head::GreaterFilter(tail, a)
    else
        GreaterFilter(tail, a);


GreaterFilter([], 2);
GreaterFilter([0,1,2,3,4,5], 2);
GreaterFilter([2, 6, 4, 6, 5, 3, 7, 7], 4);
