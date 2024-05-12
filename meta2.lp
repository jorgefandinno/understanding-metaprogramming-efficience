conjunction(B) :- literal_tuple(B), hold(L) : literal_tuple(B, L), L > 0.


#external hold(A) : atom_tuple(H,A).

#show.
#show T: output(T,B), conjunction(B).