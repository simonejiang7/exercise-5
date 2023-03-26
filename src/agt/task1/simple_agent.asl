// simple agent

/* Initial rules */
/* Task 1.2.3 Start of your solution */
even(X) :- X mod 2 == 0.
odd(X) :- X mod 2 == 1.
/* Task 1.2.3 End of your solution */

/* Initial goals */
// !start_sum(4,2). // uncomment for Task 1.2.1
// !start_sum(4,-2). // uncomment for Task 1.2.1
// !start_division(4,2). // uncomment for Task 1.2.2
// !start_division(4,2.5). // uncomment for Task 1.2.2
// !start_division(4,0). // uncomment for Task 1.2.2
// !start_even_or_odd(4). // uncomment for Task 1.2.3
// !start_even_or_odd(5). // uncomment for Task 1.2.3
!start_list_generation(0,4). // uncomment for Task 1.2.4
// !print_list([0,1,2,3,4]). // uncomment for an example of handling a list with recursion

/* 
 * Plan for reacting to the addition of the goal !start_sum
 * Triggering event: addition of goal !start_sum
 * Context: true (the plan is always applicable)
 * Body: creates the goal of computing the Sum of X and Y
*/
@start_sum_task_1_2_1_plan
+!start_sum(X,Y) : true <- 
    !compute_sum(Y,X,Sum);// creates the goal !compute_sum(Y,X,Sum)
    .print(X, "+", Y, "=", Sum).

/* Task 1.2.1 Start of your solution */
@compute_sum_task_1_2_1_plan
+!compute_sum(X,Y,Sum) : true <-
    .print("Implement Task 1.2.1");
    Sum = X + Y.

/* Task 1.2.1 End of your solution */

@start_division_task_1_2_2_plan
+!start_division(Dividend,Divisor) : true <- 
    !compute_division(Dividend, Divisor, Quotient);
    .print(Dividend, "/", Divisor, "=", Quotient).

/* Task 1.2.2 Start of your solution */
@compute_division_task_1_2_2_plan_success
+!compute_division(Dividend,Divisor,Quotient) : true & Divisor \==0 <-
    .print("Implement Task 1.2.2");
    Quotient = Dividend / Divisor.

/* Task 1.2.2 End of your solution */

/* 
 * Plan for reacting to the failure of the goal !compute_division(Dividend,Divisor,_)
 * Triggering event: deletion of goal !compute_division(Dividend,Divisor,_)
 * Context: true (the plan is always applicable)
 * Body: informs about the failure
*/
@compute_division_failure_task_1_2_2_plan
-!compute_division(Dividend,Divisor,_) : true <-
    .print("Unable to compute the division of ", Dividend, " by ", Divisor).

/* 
 * Plan for reacting to the addition of the goal !start_even_or_odd(X)
 * Triggering event: addition of goal !start_even_or_odd(X)
 * Context: X is even
 * Body: informs that X is even
*/
@start_even_1_2_3_plan
+!start_even_or_odd(X) : even(X) <-
    .print(X, " is even").

/* 
 * Plan for reacting to the addition of the goal !start_even_or_odd(X)
 * Triggering event: addition of goal !start_even_or_odd(X)
 * Context: X is odd
 * Body: informs that X is odd
*/
@start_odd_1_2_3_plan
+!start_even_or_odd(X) : odd(X) <-
    .print(X, " is odd").

/* 
 * Plan for reacting to the failure of the goal !start_even_or_odd(X)
 * Triggering event: deletion of goal !start_even_or_odd(X)
 * Context: true (the plan is always applicable)
 * Body: informs about the failure
*/
@start_even_or_odd_failure_1_2_3_plan
-!start_even_or_odd(X) : true <-
    .print("Unable to compute if ", X, " is even or odd").

/* 
 * Plan for reacting to the addition of the goal !start_list_generation(Start, End)
 * Triggering event: addition of goal !start_list_generation(Start, End)
 * Context: true (the plan is always applicable)
 * Body: creates the goal of computing a list List that contains the integers in range [Start, End]
*/
@start_list_generation_1_2_4_plan
+!start_list_generation(Start, End) : true <-
//    !compute_list(Start, End, [], List);
//    .print("List with integers from ", Start, " to ", End, ": ", List).
   !compute_list(Start, End, []);
   .print("List with integers from ", Start, " to ", End, ": ", List).

/* Task 1.2.4 Start of your solution */
@compute_list_1_2_4_plan
+!compute_list(Start, End, StartList): Start < End <- 
    List = [Start|StartList];
    .print("List: ", List);
    NextStart = Start + 1;
    !compute_list(NextStart, End, List).

// You are allowed to use a triggering event other than the one provided 
/* Task 1.2.4 End of your solution */

/* 
 * Plan for reacting to the failure of the goal !compute_list(Start, End,_,_)
 * Triggering event: deletion of goal !compute_list(Start, End,_,_)
 * Context: true (the plan is always applicable)
 * Body: informs about the failure
*/
-!compute_list(Start, End,_) : true <-
    .print("Unable to compute a list with integers from ", Start, " to ", End).

/* 
 * Plan for reacting to the addition of the goal !print_list([])
 * Triggering event: addition of goal !print_list([])
 * Context: true (the plan is always applicable)
 * Body: informs that all list elements have been printed
*/
@print_empty_list_plan
+!print_list([]) : true <-
    .print("All elements have been printed.").

/* 
 * Plan for reacting to the addition of the goal !print_list([Element | RemainingList])
 * Triggering event: addition of goal !print_list([Element | RemainingList])
 * Context: true (the plan is always applicable)
 * Body: recursively prints the fist element from the list. The remaining elements are stored in the list RemainingList
*/
@print_list_plan
+!print_list([Element | RemainingList]) : true <-
    .print("List element: ", Element);
    !print_list(RemainingList).