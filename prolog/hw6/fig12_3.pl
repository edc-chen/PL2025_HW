% fig12_3.pl
% Best-first search program modified to count nodes and output statistics

:- dynamic node_count/1.
:- dynamic generated_node/1.

node_count(0).

% reset_nodes: resets the node counter and clears generated nodes.
reset_nodes :-
    retractall(node_count(_)),
    assert(node_count(0)),
    retractall(generated_node(_)).

% inc_node(Node): increments the node counter and records the generated node.
inc_node(Node) :-
    retract(node_count(N)),
    N1 is N + 1,
    assert(node_count(N1)),
    assert(generated_node(Node)).

% bestfirst(Start, Solution):
% Finds a solution path from Start to a goal.
% 修改處：在搜尋成功後呼叫 print_stats/0，直接印出統計資訊。
bestfirst(Start, Solution) :-
    reset_nodes,
    inc_node(Start),          % count the start node
    expand([], l(Start, 0/0), 9999, _, yes, Solution),
    print_stats.

% expand(Path, Tree, Bound, Tree1, Solved, Solution):

% Case 1: If a leaf node is a goal.
expand(P, l(N, _), _Bound, _, yes, [N|P]) :-
    goal(N).

% Case 2: Leaf node with f-value less than Bound: generate successors.
expand(P, l(N, F/G), Bound, _Tree1, Solved, Sol) :-
    F =< Bound,
    ( bagof(M/C, ( s(N, M, C), \+ member(M, P) ), Succ)
      -> succlist(G, Succ, Ts),
         bestf(Ts, F1),
         expand(P, t(N, F1/G, Ts), Bound, _Tree1, Solved, Sol)
      ;  Solved = never, Sol = []  % no successors: dead end
    ).

% Case 3: Non-leaf node with f-value less than Bound.
expand(P, t(N, F/G, [T|Ts]), Bound, Tree1, Solved, Sol) :-
    F =< Bound,
    bestf(Ts, BF),
    min(Bound, BF, Bound1),
    expand([N|P], T, Bound1, T1, Solved1, Sol),
    continue(P, t(N, F/G, [T1|Ts]), Bound, Tree1, Solved1, Solved, Sol).

% Case 4: Non-leaf node with empty subtree (dead end).
expand(_, t(_,_,[]), _Bound, _, never, _) :- !.

% Case 5: When f-value > Bound: do not expand.
expand(_, Tree, Bound, Tree, no, _) :-
    f(Tree, FValue),
    FValue > Bound.

% continue(Path, Tree, Bound, NewTree, SubtreeSolved, TreeSolved, Solution)
continue(_, _, _, _, yes, yes, Sol).
continue(P, t(N, _F/G, [T1|Ts]), Bound, Tree1, no, Solved, Sol) :-
    insert(T1, Ts, NTs),
    bestf(NTs, F1),
    expand(P, t(N, F1/G, NTs), Bound, Tree1, Solved, Sol).
continue(P, t(N, _F/G, [_|Ts]), Bound, Tree1, never, Solved, Sol) :-
    bestf(Ts, F1),
    expand(P, t(N, F1/G, Ts), Bound, Tree1, Solved, Sol).

% succlist(G0, [Node/Cost, ...], [l(BestNode, BestF/G), ...]):
% Convert each successor into a search leaf and record it.
succlist(_, [], []).
succlist(G0, [N/C|NCs], Ts) :-
    G is G0 + C,
    h(N, H),         % Heuristic function h/2 (defined in fig12_6.pl)
    F is G + H,
    inc_node(N),     % record the new node
    succlist(G0, NCs, Ts1),
    insert(l(N, F/G), Ts1, Ts).

% insert(T, Ts, NewTs): Insert T into Ts preserving the order by f-value.
insert(T, [], [T]).
insert(T, [T1|Ts], [T, T1|Ts]) :-
    f(T, F),
    bestf([T1|Ts], F1),
    F =< F1, !.
insert(T, [T1|Ts], [T1|Ts1]) :-
    insert(T, Ts, Ts1).

% f(Tree, F): extract the f-value from a leaf or a tree.
f(l(_, F/_), F).
f(t(_, F/_, _), F).

% bestf(List, F): the best (lowest) f-value in the list.
bestf([T|_], F) :-
    f(T, F).
bestf([], 9999).

% min(X, Y, X) if X =< Y; otherwise Y.
min(X, Y, X) :- X =< Y, !.
min(_, Y, Y).

% print_stats: prints the total number of generated nodes and the list of generated nodes.
print_stats :-
    node_count(Count),
    findall(Node, generated_node(Node), Nodes),
    format('Total number of nodes generated: ~w~n', [Count]),
    format('Total nodes generated: ~w~n', [Nodes]).
