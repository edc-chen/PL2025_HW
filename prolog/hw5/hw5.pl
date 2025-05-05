% Declare dynamic predicates for instances and parent-child relationships.
:- dynamic instance/2.
:- dynamic child/2.

%% --- Class declarations and hierarchy ---
%
% There are three classes: lane (abstract), stage and swimlane (concrete subclasses).
%
class(lane).
class(stage).
class(swimlane).

abstract(lane).
concrete(stage).
concrete(swimlane).

% Relationship: stage and swimlane are subclasses of lane.
subclass(stage, lane).
subclass(swimlane, lane).

%% --- Instance creation ---
%
% new_instance(Instance, Class) succeeds only if Class is concrete.
%
new_instance(Instance, Class) :-
    concrete(Class),
    \+ instance(Instance, _),  % ensure no duplicate instance
    assert(instance(Instance, Class)).
    
%% --- Parent-child relationships ---
%
% An instance can have children (sub-lanes). The predicate add_child(Child, Parent)
% adds a child to a parent if all the following constraints are met:
%
% 1. Child is not the same as Parent.
% 2. The relation will not introduce a cycle:
%    - The new Child must not be an ancestor of Parent.
%    - The new Child must not be already a descendant of Parent.
% 3. If Parent already has at least one child then the concrete class of Child
%    must match that of the existing children.
% 4. Each instance may have at most one parent.
%
% When a rule is violated an appropriate error message is printed.
%
% (Note: In all cases the predicate succeeds with true even when the addition is rejected.)
%

% We define descendant/2 as:
descendant(Parent, Child) :-
    child(Parent, Child).
descendant(Parent, Descendant) :-
    child(Parent, Intermediate),
    descendant(Intermediate, Descendant).

% Get direct children of a Parent.
children(Parent, Children) :-
    findall(Child, child(Parent, Child), Children).

% Clause-based definitions for add_child/2 to enforce the constraints.

add_child(Child, Parent) :-
    instance(Child, _),
    instance(Parent, _),
    Child == Parent,
    !,
    writeln('Child not added: cannot add self as child').
    
add_child(Child, Parent) :-
    instance(Child, _),
    descendant(Child, Parent),
    !,
    % That is: Parent appears in the descendant chain of Child 
    % (i.e. Child is an ancestor of Parent).
    writeln('Child not added: cannot add an ancestor as a new child').
    
add_child(Child, Parent) :-
    instance(Child, _),
    descendant(Parent, Child),
    !,
    % That is: Child is already a descendant of Parent.
    writeln('Child not added: cannot add a descendant as a new child').
    
add_child(Child, Parent) :-
    instance(Child, ChildClass),
    children(Parent, CList),
    CList \= [],
    CList = [ExistingChild|_],
    instance(ExistingChild, ExistingClass),
    ChildClass \== ExistingClass,
    !,
    writeln('Child not added: cannot add a child with different class').
    
add_child(Child, Parent) :-
    child(_, Child),  % Child already has some parent.
    !,
    writeln('Child not added: cannot add a child that is already a child of another parent').
    
add_child(Child, Parent) :-
    % If none of the error conditions hold then add the relation.
    assert(child(Parent, Child)).

%% --- Descendants ---
%
% descendants(Parent, Descendants) returns a list of (direct and indirect)
% children of Parent. The recursive definition of descendant/2 is used.
%
descendants(Parent, Descendants) :-
    findall(D, descendant(Parent, D), Descendants).

%% --- Valid children check ---
%
% valid_children(Instance) succeeds if the given instance satisfies the rule that
% all its children are of the same concrete class.
%
valid_children(Instance) :-
    children(Instance, Children),
    ( Children = [] -> true 
    ; Children = [FirstChild | Rest],
      instance(FirstChild, Class),
      forall(member(Child, Rest), (instance(Child, Class)))
    ).
