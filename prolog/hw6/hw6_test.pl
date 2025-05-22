% hw6_test.pl
:- begin_tests(eight_puzzle).

% 測試總節點數是否為 10。
test(total_nodes, [cleanup(reset_nodes)]) :-
    % 由 bestfirst 自動呼叫 reset_nodes
    start1(Pos),
    bestfirst(Pos, _Sol),
    node_count(Count),
    assertion(Count =:= 10).

% 測試生成的節點列表是否與預期結果一致。
test(generated_nodes, [cleanup(reset_nodes)]) :-
    start1(Pos),
    bestfirst(Pos, _Sol),
    findall(Node, generated_node(Node), Nodes),
    Expected = [
      [2/2,1/3,3/2,2/3,3/3,3/1,2/1,1/1,1/2],
      [3/2,1/3,2/2,2/3,3/3,3/1,2/1,1/1,1/2],
      [2/3,1/3,3/2,2/2,3/3,3/1,2/1,1/1,1/2],
      [2/1,1/3,3/2,2/3,3/3,3/1,2/2,1/1,1/2],
      [1/2,1/3,3/2,2/3,3/3,3/1,2/1,1/1,2/2],
      [3/3,1/3,2/2,2/3,3/2,3/1,2/1,1/1,1/2],
      [3/1,1/3,2/2,2/3,3/3,3/2,2/1,1/1,1/2],
      [2/3,1/3,2/2,3/3,3/2,3/1,2/1,1/1,1/2],
      [1/3,2/3,2/2,3/3,3/2,3/1,2/1,1/1,1/2],
      [2/2,1/3,2/3,3/3,3/2,3/1,2/1,1/1,1/2]
    ],
    assertion(Nodes == Expected).

:- end_tests(eight_puzzle).
