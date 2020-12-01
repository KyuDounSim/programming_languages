/*p1:*/ parent(a,b).
/*p2:*/ parent(a,c).
/*p3:*/ parent(b,d).
/*p4:*/ parent(b,e).
/*p5:*/ parent(d,f).

/*anc1:*/ ancestor(X,Y) :- parent(X,Y).
/*anc2:*/ ancestor(X,Y) :- parent(X,Z), ancestor(Z,Y).

