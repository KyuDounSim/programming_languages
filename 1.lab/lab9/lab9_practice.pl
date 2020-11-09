list_prefix(a, b).
list_suffix(a, b).
list_prefix_suffix(a, b) :- list_prefix(a, b); list_suffix(a, b);
