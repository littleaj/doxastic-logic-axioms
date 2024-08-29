use_module(library(lists)).
%% Agents:
%%    Entities which can hold beliefs and belong to social `groups`.

:- dynamic agent_details/1.
:- dynamic agents/1.

agents(SetOfAgents) :-
  is_set(SetOfAgents),
  forall(member(Agent, SetOfAgents), atom(Agent)),
  retractall(agent_details(_)),
  foreach(member(Agent, SetOfAgents), assertz(Agent :- agent_details(Agent))).
is_agent(Agent) :-
  agents(Set), member(Agent, Set), !.
  % agent_details(Agent), !.

is_belief(Belief) :- atom(Belief).
is_belief(Belief) :- compound(Belief).

holds_beliefs(Agent, Beliefs) :-
  is_agent(Agent),
  is_set(Beliefs),
  forall(member(B, Beliefs), is_belief(B)).

believes(Agent, Prop) :-
  holds_beliefs(Agent, BeliefsOfAgent),
  member(Prop, BeliefsOfAgent).

groups(Groups) :-
  is_set(Groups),
  forall(member(G, Groups), atom(G)).
is_group(G) :- groups(S), member(G, S).
group_members(G, Memebers) :-
  is_group(G), is_set(Memebers),
  forall(member(M, Memebers), is_agent(M)).

in_group(A, G) :-
  group_members(G, Members),
  member(A, Members).
in_groups(Agent, Groups) :-
  findall(G, in_group(Agent, G), Result),
  list_to_set(Result, Groups).

reasoner_types(R) :- is_set(R), forall(member(M, R), atom(M)).
is_rt(R) :- reasoner_types(Types), member(R, Types).

is_reasoner(Agent, Type) :- is_agent(Agent), is_rt(Type).

agent_details(A) :-
  holds_beliefs(A, Beliefs),
  in_groups(A, Groups),
  is_reasoner(A, Reasoning),
  format('Agent: ~w~n', [A]),
  format('Beliefs: ~w~n', [Beliefs]),
  format('Groups: ~w~n', [Groups]),
  format('R-Type: ~w~n', [Reasoning]).
