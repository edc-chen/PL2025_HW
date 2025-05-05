:- begin_tests(hw5).

% 先載入待測試的程式模組 hw5.pl
:- [hw5].

% 每次測試前，清除所有動態事實，確保各測試間互不干擾
setup :-
    retractall(instance(_,_)),
    retractall(child(_,_)).

%% 1. 測試 new_instance/2 成功建立具體類別的實例
test(new_instance_success, [setup(setup)]) :-
    new_instance(i, stage),
    assertion(instance(i, stage)).

%% 2. 測試 new_instance/2 嘗試用抽象類別建立實例應該失敗
test(new_instance_failure_abstract, [setup(setup), fail]) :-
    new_instance(i, lane).

%% 3. 測試加入子線 (add_child/2) 成功 (父節點尚無子線時)
test(add_child_valid, [setup(setup)]) :-
    new_instance(s1, stage),
    new_instance(l3, swimlane),
    add_child(l3, s1),
    children(s1, Children),
    assertion(Children == [l3]).

%% 4. 測試當父節點已有子線時，嘗試加入不同類別的子線會被拒絕
test(add_child_different_class, [setup(setup)]) :-
    new_instance(s1, stage),
    new_instance(l3, swimlane),   % l3 屬於 swimlane
    new_instance(s2, stage),       % s2 屬於 stage
    add_child(l3, s1),             % 先加 l3 成為 s1 的子線
    add_child(s2, s1),             % 再嘗試加 s2 (不同類別) 應拒絕
    children(s1, Children),
    assertion(Children == [l3]).

%% 5. 測試「祖先循環錯誤」：不能將祖先作為新的子線加入
test(add_child_ancestor_error, [setup(setup)]) :-
    new_instance(s1, stage),
    new_instance(l3, swimlane),
    new_instance(s2, stage),
    add_child(l3, s1),    % s1 -> l3
    add_child(s2, l3),    % l3 -> s2, 使 s1 成為 s2 的祖先
    add_child(s1, s2),    % 嘗試將 s1 加入 s2 作為子線，應被拒絕
    \+ child(s2, s1).

%% 6. 測試「後代循環錯誤」：不能將後代作為新的子線加入
test(add_child_descendant_error, [setup(setup)]) :-
    new_instance(s1, stage),
    new_instance(l3, swimlane),
    new_instance(s2, stage),
    add_child(l3, s1),    % s1 -> l3
    add_child(s2, l3),    % s2 成為 s1 的後代
    add_child(s2, s1),    % 嘗試將 s2 加入 s1 作為子線，應被拒絕
    children(s1, Children),
    assertion(Children == [l3]).

%% 7. 測試同一個子節點只能有唯一父節點
test(add_child_already_child, [setup(setup)]) :-
    new_instance(l4, swimlane),
    new_instance(l5, swimlane),
    new_instance(s2, stage),
    add_child(l5, l4),    % l4 -> l5
    add_child(l5, s2),    % 嘗試將 l5 同時加入另一父節點 s2，應被拒絕
    children(l4, C1),
    children(s2, C2),
    assertion(C1 == [l5]),
    assertion(C2 == []).

%% 8. 測試 children/2 與 descendants/2 的查詢功能
test(children_and_descendants, [setup(setup)]) :-
    % 建立結構：s1 -> [l3, l4]；l3 -> [s2]
    new_instance(s1, stage),
    new_instance(l3, swimlane),
    new_instance(l4, swimlane),
    new_instance(s2, stage),
    add_child(l3, s1),
    add_child(l4, s1),
    add_child(s2, l3),
    children(s1, Children),
    descendants(s1, Descendants),
    sort(Children, SortedChildren),
    assertion(SortedChildren == [l3, l4]),
    sort(Descendants, SortedDescendants),
    assertion(SortedDescendants == [l3, l4, s2]).

%% 9. 測試 valid_children/1 當存在子線時返回 true
test(valid_children_true, [setup(setup)]) :-
    new_instance(s1, stage),
    new_instance(l3, swimlane),
    new_instance(l4, swimlane),
    add_child(l3, s1),
    add_child(l4, s1),
    assertion(valid_children(s1)).

%% 10. 測試 valid_children/1 當沒有子線時也返回 true
test(valid_children_empty, [setup(setup)]) :-
    new_instance(a, stage),
    assertion(valid_children(a)).

:- end_tests(hw5).

% 執行測試時，在 Prolog 提示符中輸入 ?- run_tests.
