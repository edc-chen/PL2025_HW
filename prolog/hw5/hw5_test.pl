:- use_module(library(plunit)).
:- use_module(hw5).
:- begin_tests(hw5).


% 每個測試前先清除所有動態宣告的事實 (instance/2 與 child/2)，確保測試間不互相干擾。
reset :-
    retractall(instance(_, _)),
    retractall(child(_, _)).


test(class_lane) :-
    class(lane).

test(valid_stage) :-
    class(stage).

test(valid_swimlane) :-
    class(swimlane).

test(abstract_lane) :-
    abstract(lane).

test(abstract_stage_and_swimlane) :-
    \+ abstract(stage),
    \+ abstract(swimlane).

test(concrete_stage) :-
    concrete(stage).

test(concrete_swimlane) :-
    concrete(swimlane).

test(concrete_lane) :-
    \+ concrete(lane).

test(subclass_relationships) :-
    subclass(stage, lane),
    subclass(swimlane, lane).

test(subclass_relationships) :-
    \+ subclass(lane, stage),
    \+ subclass(lane, swimlane).

% --- new_instance/2 ---
test(new_instance_success, [setup(reset)]) :-
    new_instance(i, stage),
    instance(i, stage).

test(new_instance_failure_on_abstract, [setup(reset)]) :-
    \+ new_instance(i, lane).  % Abstract class should fail

test(new_instance_duplicate, [setup(reset), fail]) :-
    new_instance(i, stage),
    new_instance(i, stage).  % Duplicate instance should fail

% --- add_child/2 success and failure cases ---
test(add_child_success, [setup(reset)]) :-
    new_instance(s1, stage),
    new_instance(l3, swimlane),
    add_child(l3, s1),
    child(l3, s1).

test(add_child_self, [setup(reset)]) :-
    new_instance(s1, stage),
    children(s1, Children),  % Check children of s1
    Children == [].  % No child should be added

test(add_child_ancestor_cycle, [setup(reset)]) :-
    new_instance(s1, stage),
    new_instance(l3, swimlane),
    add_child(l3, s1),
    new_instance(s2, stage),
    add_child(s2, l3),
    children(s1, Children),  % Check children of s1
    Children == [l3].  % s1 should not have s2 as a child

test(add_child_descendant_cycle, [setup(reset)]) :-
    new_instance(s1, stage),
    new_instance(l3, swimlane),
    new_instance(s2, stage),
    add_child(l3, s1),
    add_child(s2, l3),
    children(s1, Children),  % Check children of s1
    Children == [l3].  % s1 should not have s2 as a child

test(add_child_already_has_parent, [setup(reset)]) :-
    new_instance(s1, stage),
    new_instance(s2, stage),
    new_instance(l4, swimlane),
    add_child(l4, s1),
    children(s1, Children),  % Check children of s1
    Children == [l4].  % l4 should still only be a child of s1

test(add_child_class_mismatch, [setup(reset)]) :-
    new_instance(s1, stage),
    new_instance(s2, stage),
    children(s1, Children),  % Check children of s1
    Children == [].  % No child should be added

test(add_child_valid_class, [setup(reset)]) :-
    new_instance(s1, stage),
    new_instance(l3, swimlane),
    add_child(l3, s1),
    valid_children(s1).

% --- children/2 ---
test(children_retrieval, [setup(reset)]) :-
    new_instance(s1, stage),
    new_instance(l3, swimlane),
    new_instance(l4, swimlane),
    add_child(l3, s1),
    add_child(l4, s1),
    children(s1, Children),
    sort(Children, Sorted),
    Sorted == [l3, l4].

% --- descendants/2 ---
test(descendants_deep, [setup(reset)]) :-
    new_instance(s1, stage),
    new_instance(l3, swimlane),
    new_instance(s2, stage),
    add_child(l3, s1),
    add_child(s2, l3),
    descendants(s1, Descendants),
    sort(Descendants, Sorted),
    Sorted == [l3, s2].

% --- valid_children/1 ---
test(valid_children_true, [setup(reset)]) :-
    new_instance(s1, stage),
    new_instance(l3, swimlane),
    new_instance(l4, swimlane),
    add_child(l3, s1),
    add_child(l4, s1),
    valid_children(s1).

test(valid_children_1, [setup(reset)]) :-
    new_instance(s1, stage),
    new_instance(l3, swimlane),
    new_instance(s2, stage),
    add_child(l3, s1),
    add_child(s2, s1),
    valid_children(s1).  % Different classes should return false

test(valid_children_empty, [setup(reset)]) :-
    new_instance(s1, stage),
    valid_children(s1).  % No children: valid by default

:- end_tests(hw5).

% 執行單元測試：
% 在 Prolog 提示符中輸入 ?- run_tests.
