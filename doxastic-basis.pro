%% Agents:
%%    Entities which can hold beliefs and belong to social `groups`.

agents(A) :-
  is_set(A),
  forall(member(M, A), atom(M)),
  foreach(member(M, A), assertz(M :- agent_details(M))),
  !.
is_agent(A) :- agents(S), member(A, S), !.

is_belief(B) :- atom(B).
is_belief(B) :- compound(B).

holds_beliefs(Agent, B) :-
  is_agent(Agent),
  is_set(B),
  forall(member(M, B), is_belief(M)),
  !.

has_belief(Agent, Prop) :-
  holds_beliefs(Agent, BeliefsOfAgent),
  member(Prop, BeliefsOfAgent),
  !.

groups(Groups) :-
  is_set(Groups),
  forall(member(G, Groups), atom(G)),
  !.
is_group(G) :- groups(S), member(G, S), !.
group_members(G, Memebers) :-
  is_group(G), is_set(Memebers),
  forall(member(M, Memebers), is_agent(M)),
  !.

in_group(A, G) :-
  group_members(G, Members),
  member(A, Members),
  !.
in_groups(Agent, Groups) :-
  findall(G, in_group(Agent, G), Result),
  list_to_set(Result, Groups),
  !.

reasoner_types(R) :- is_set(R), forall(member(M, R), atom(M)), !.
is_rt(R) :-
  reasoner_types(Types), member(R, Types), !.

is_reasoner(Agent, Type) :-
  is_agent(Agent), is_rt(Type), !.

agent_details(A) :-
  holds_beliefs(A, Beliefs),
  in_groups(A, Groups),
  is_reasoner(A, Reasoning),
  format('Agent: ~w~n', [A]),
  format('Beliefs: ~w~n', [Beliefs]),
  format('Groups: ~w~n', [Groups]),
  format('R-Type: ~w~n', [Reasoning]),
  !.
