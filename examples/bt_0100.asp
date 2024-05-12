%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% arguments %%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% input: input_length(L).
u(max_length(L)) :- u(input_length(L)).
u(num_packages(L)) :- u(input_length(L)).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% initial states %%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
u(package((1..NP))) :- u(num_packages(NP)).
{ u(holds(armed(P),0)) } :- u(package(P)).
#false :- not 1 <= { u(holds(armed(P),0)): u(package(P)) } <= 1.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% problem description %%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%  fluents   %%%%%%%%%%%%%%%%%%
u(fluent(armed(P))) :- u(package(P)).
u(inertial(armed(P))) :- u(package(P)).
u(fluent(dunked(P))) :- u(package(P)).
u(inertial(dunked(P))) :- u(package(P)).
u(fluent(unsafe)).
%%%%%%%  actions   %%%%%%%%
u(action(dunk(P))) :- u(package(P)).
%%%%%%  executable  %%%%%%%
u(executable(dunk(P),T)) :- u(action(dunk(P))); u(step(T)); not u(holds(dunked(P),T)).
%%%%%  direct effects   %%%%%%%
u(-holds(armed(P),(T+1))) :- u(occurs(dunk(P),T)); u(step(T)).
u(holds(dunked(P),(T+1))) :- u(occurs(dunk(P),T)); u(step(T)).
%%%%%  indirect effects   %%%%%%%
u(holds(unsafe,T)) :- u(holds(armed(P),T)); u(step(T)).
u(-holds(unsafe,T)) :- not u(holds(unsafe,T)); u(step(T)).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% arguments %%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% input: input_length(L).
% input: num_packages(NPL).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% problem description %%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
u(step((0..L))) :- u(max_length(L)).
u(stepless((0..(L-1)))) :- u(max_length(L)).
%%%%% occurs  %%%%%%%
u(occurs(A,S)) :- u(action(A)); u(stepless(S)); not k(not1(u(occurs(A,S)))).
{ k(not1(u(occurs(A,S)))) } :- not1(u(occurs(A,S))).
not1(u(occurs(A,S))) :- u(action(A)); u(stepless(S)); not u(occurs(A,S)).
u(bot) :- u(occurs(A,S)); not u(executable(A,S)).
#false :- 1 < { u(occurs(A,S)) }; u(stepless(S)).
%%%%% goal  %%%%%%%
u(goal) :- u(-holds(unsafe,LEN)); not u(bot); u(max_length(LEN)).
#false :- not k(u(goal)).
{ k(u(goal)) } :- u(goal).
%%%%% defaults and inertia  %%%%%%%
u(-holds(F,0)) :- not u(holds(F,0)); u(fluent(F)).
u(holds(F,(S+1))) :- u(fluent(F)); u(inertial(F)); u(stepless(S)); u(holds(F,S)); not u(-holds(F,(S+1))).
u(-holds(F,(S+1))) :- u(fluent(F)); u(inertial(F)); u(stepless(S)); u(-holds(F,S)); not u(holds(F,(S+1))).
u(input_length(100)).
