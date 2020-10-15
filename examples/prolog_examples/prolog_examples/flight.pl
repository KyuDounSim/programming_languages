df(hk,tk).
df(hk,bj).
df(hk,sf).
df(tk,hk).
df(tk,vr).

f(X,Y):-df(X,Y).
f(X,Z):-df(X,Y),f(Y,Z).
