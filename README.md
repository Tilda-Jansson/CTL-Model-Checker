# CTL Model Checker: Implementing and Verifying a Subset of Temporal Logic CTL

This project implements a model checker for a subset of the temporal logic CTL.
The model checker verifies if a given temporal logic formula φ holds in a certain state s of a given model M.

The implemented model checker follows the provided CTL rules and breaks down the given formula recursively to determine its validity in the model.

## Methodology

The model checker first reads the input data file using the *verify* predicate
provided in the lab instructions, which consists of Prolog terms. It then divides
the input data into four variables: T (neighbor lists), L (state-holding variables),
S (state), U (previously checked states), and F (CTL formula).

The program recursively breaks down the given formula to be checked in the model.
The formula is unified with a variant of the *check* predicate. Rules for
CTL have been implemented using different variants of the *check* predicate.
Throughout the recursion, all formulas will eventually reach the two *check* predicates
(literals) handling atoms, where the validity of the variable in the state is checked.

The *check* predicates for *And* and *Or* accept two CTL formulas *F* and *G*. For *And*, both *F* and *G* must hold,
while for *Or*, at least one of them must hold.

## Implemented Predicates

* **AX**: Checks if the formula/variable X holds in all neighboring states.
 To achieve this, the program retrieves the list of neighboring states using the *getNeigh_OR_var* predicate,
 iterates through the list using the *check_neighbours* predicate, and checks if X holds in each neighboring state using the *check* predicate.

* **EX**: Checks if the formula/variable X holds in any neighboring state. The program retrieves the list of neighboring states using the *getNeigh_OR_var* predicate and checks if X holds in any of the neighboring states using the *member* predicate.

* **AG**: Checks if the formula/variable X always holds in all states. First, it checks if X holds in the current state and if the state is not in the list U. Then, it checks if AG(X) holds in all neighboring states and adds the current state to the list U. The base case for recursion is when a loop is encountered (i.e., the state has been visited before), which means "success."

* **EG**: Checks if there is a path where the formula/variable X always holds. In the recursive case, the program first checks if X holds in the current state and if the state is not in the list U. Then, it checks if EG(X) holds in any neighboring state using the *member* predicate. The current state is also added to the list U. The base case for recursion is when a loop is encountered (i.e., the state is already in the list U).

* **EF**: Checks if there is a path where X eventually holds. The program first checks if the current state is not in the list U. Then, it checks if any neighboring state has EF(X) holding using the *member* predicate and adds the current state to the list U. The base case for recursion is when an unvisited state is encountered where X holds.

* **AF**: Checks if X eventually holds in all paths, in some state. The program first checks if the current state is not in the list U. Then, it retrieves the list of neighboring states, uses the *check_neighbours* predicate to iterate through the neighbor list and checks if AF(X) holds in all neighboring states. The current state is added to the list U. The base case for recursion is when an unvisited state is encountered where X holds.
