fun filter f [ ] = [ ]
|   filter f (head::tail) = 
        if (f head)
        then head::(filter f tail) 
        else (filter f tail);
fun reduce f [ ] v = v
|   reduce f (head::tail) v = f (head, reduce f tail v);
fun add (x,y) = x+y;
fun mul (x,y) = x*y;
fun bool2int (x) = if x then 1 else 0;
