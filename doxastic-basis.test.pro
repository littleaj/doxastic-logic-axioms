:- consult('./doxastic-basis.pro').
:- begin_tests(doxastic_basis).

test(define_agents) :-
  assertz(agents([a, b, c])),
  is_agent(a),
  is_agent(b),
  is_agent(c),
  a,
  b,
  c.


:- end_tests(doxastic_basis).

