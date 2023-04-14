
% Retunerar Granntillstånden eller variablerna som gäller i tillståndet S
getNeigh_OR_var(S, [[S, Sublist]| _], Sublist).
getNeigh_OR_var(S, [H|T], Sublist):-
  getNeigh_OR_var(S, T, Sublist).


% Iterera genom alla grannar(intilliggande tillstånd) och kontrollera att X giltig i alla
check_neighbours(_, _, [], _, _).
check_neighbours(T, L, [Neighbour1|Neighbours], U, X):-
  check(T, L, Neighbour1, U, X),
  check_neighbours(T, L, Neighbours, U, X).

% Load model, initial state and formula from file.
verify(Input) :-
  see(Input), read(T), read(L), read(S), read(F), seen,
  check(T, L, S, [], F).


% Literal
check(_, L, S, _, X) :-
  getNeigh_OR_var(S, L, Variables), member(X, Variables).

% Literal
check(_, L, S, _, neg(X)) :-
  getNeigh_OR_var(S, L, Variables), not(member(X, Variables)).

% And
check(T, L, S, _, and(F, G)) :-
  check(T, L, S, [], F), check(T, L, S, [], G).

% Or
check(T, L, S, _, or(F, G)):-
  check(T, L, S, [], F); check(T, L, S, [], G).

% AX
/*
I ALLA nästa tillstånd
*/
check(T, L, S, U, ax(X)):-
  getNeigh_OR_var(S, T, Neighbours),
  check_neighbours(T, L, Neighbours, U, X). % förgrenar sig genom grann-listan!

% EX
/*
I NÅGOT nästa tillstånd!!!!
*/
check(T, L, S, U, ex(X)):-
  getNeigh_OR_var(S, T, Neighbours),
  member(NeighbourX, Neighbours),
  check(T, L, NeighbourX, U, X).

% AG
/* (stöter på en slinga när en G-formel utvärderas betyder det “success”)
Alltid X
*/
% Basfall
check(_, _, S, U, ag(_)):-
  member(S, U), !.

/*
Rekusiva delen, lägger till S i U(besökta tillstånd)
*/
check(T, L, S, U, ag(X)):-
  not(member(S, U)),
  check(T, L, S, [], X),
  getNeigh_OR_var(S, T, Neighbours),
  check_neighbours(T, L, Neighbours, [S|U], ag(X)). % förgrenar sig genom grann-listan!

% EG
%    Det finns en väg där det alltid gäller
% Basfall
check(_, _, S, U, eg(_)):-
  member(S, U), !.

% lägg till S i U, rekursiva fallet
check(T, L, S, U, eg(X)):-
  not(member(S, U)),
  check(T, L, S, [], X),
  getNeigh_OR_var(S, T, Neighbours),
  member(NeighbourX, Neighbours),
  check(T, L, NeighbourX, [S|U], eg(X)).


% EF
% (stöter på en slinga när en F-formel utvärderas betyder det “Failure”)
%     Det finns en väg där så småningom...
% Basfall
check(T, L, S, U, ef(X)):-
  print('EF1'),
  not(member(S, U)),
  check(T, L, S, [], X).

/*
Rekusiva delen, lägger till S i U (besökta tillstånd)
*/
check(T, L, S, U, ef(X)):-
  print('EF2'),
  not(member(S, U)),
  getNeigh_OR_var(S, T, Neighbours),
  member(NeighbourX, Neighbours),
  check(T, L, NeighbourX, [S|U], ef(X)).

% AF
%  Alla vägar, så småningom, i något tillstånd
% Basfall
check(T, L, S, U, af(X)):-
  not(member(S, U)),
  print('AF1'),
  check(T, L, S, [], X).

% Rekusiva delen, lägger till S i U (besökta tillstånd)
check(T, L, S, U, af(X)):-
  not(member(S, U)),
  print('AF2'),
  getNeigh_OR_var(S, T, Neighbours),
  check_neighbours(T, L, Neighbours, [S|U], af(X)). % förgrenar sig genom grann-listan!
