:- module(hw5, [
    class/1, abstract/1, concrete/1, subclass/2,
    new_instance/2, instance/2,
    add_child/2, child/2,
    children/2, descendants/2,
    valid_children/1
]).
% 動態宣告，用來儲存實例(instance)與父子(child)關係。
:- dynamic instance/2.
:- dynamic child/2.

%%% 1. 類別定義與繼承關係 %%%

% 定義三個類別：lane, stage, swimlane
class(lane).
class(stage).
class(swimlane).

% lane 為抽象類別，其它為具體類別
abstract(lane).
concrete(stage).
concrete(swimlane).

% 建立繼承關係：stage 與 swimlane 屬於 lane 的子類
subclass(stage, lane).
subclass(swimlane, lane).

%%% 2. 實例管理 %%%

% new_instance(實例, 類別)
% 僅當指定的類別為具體類別且該實例尚未存在時才建立
new_instance(Instance, Class) :-
    concrete(Class),
    \+ instance(Instance, _),
    assert(instance(Instance, Class)).

%%% 3. 父子（子線）關係管理 %%%

% 取得某父節點的所有直接子線
children(Parent, Children) :-
    findall(Child, child(Parent, Child), Children).

% descendant(父, 子)
% 用於判斷子是否為某父節點的後代（可以是直接或間接）
descendant(Parent, Child) :-
    child(Parent, Child).
descendant(Parent, Descendant) :-
    child(Parent, Child),
    descendant(Child, Descendant).

% descendants(父, 全部後代)
% 收集所有直接與間接的後代
descendants(Parent, Descendants) :-
    findall(D, descendant(Parent, D), Descendants).

%%% 4. 新增子線 (add_child) %%%

% 當嘗試將 Child 加入 Parent 中時，要滿足以下條件：
% (1) 不能自己當自己的子線
add_child(Child, Parent) :-
    Child == Parent,
    !,
    writeln('Child not added: cannot add self as child'),
    true.
    
% (2) 不能將祖先作為新的子線（以免形成循環）
add_child(Child, Parent) :-
    descendant(Child, Parent),
    !,
    writeln('Child not added: cannot add an ancestor as a new child'),
    true.
    
% (3) 不能加入已是父節點後代的子線
add_child(Child, Parent) :-
    descendant(Parent, Child),
    !,
    writeln('Child not added: cannot add a descendant as a new child'),
    true.
    
% (4) 如果 Parent 已有子線，則新加入子線必須與現有子線的具體類別相同
add_child(Child, Parent) :-
    children(Parent, ExistingChildren),
    ExistingChildren \= [],
    ExistingChildren = [FirstChild | _],
    instance(FirstChild, ExistingChildClass),
    instance(Child, ChildClass),
    ChildClass \== ExistingChildClass,
    !,
    writeln('Child not added: cannot add a child with different class'),
    true.
    
% (5) 若該 Child 已屬於另一個父節點，則不允許加入新父節點
add_child(Child, _Parent) :-
    child(_, Child),
    !,
    writeln('Child not added: cannot add a child that is already a child of another parent'),
    true.
    
% (6) 若上述皆無違反約束，則可正常加入父子關係
add_child(Child, Parent) :-
    assert(child(Parent, Child)).

%%% 5. 驗證子線有效性 %%%

% valid_children(實例)
% 檢查某個實例的所有直接子線是否都屬於同一個具體類別
valid_children(Instance) :-
    children(Instance, Children),
    ( Children = [] -> true
    ; Children = [First | Rest],
      instance(First, Class),
      forall(member(C, Rest), instance(C, Class))
    ).
