atom_elements(c1,carbon,[c2,h6]).
atom_elements(c2,carbon,[c1,c3,h1]).
atom_elements(c3,carbon,[c2,c4,h2]).
atom_elements(c4,carbon,[c3,c5,h3]).
atom_elements(c5,carbon,[c4,c6,h5]).
atom_elements(c6,carbon,[c5,h4]).

atom_elements(h1,hydrogen,[c2]).
atom_elements(h2,hydrogen,[c3]).
atom_elements(h3,hydrogen,[c4]).
atom_elements(h4,hydrogen,[c6]).
atom_elements(h5,hydrogen,[c5]).
atom_elements(h6,hydrogen,[c1]).
