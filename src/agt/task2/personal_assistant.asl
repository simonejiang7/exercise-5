// personal assistant agent 

/* Task 2 Start of your solution */

best_option(vibrations) :- ranking_light(Rlight) & ranking_blinds(Rblinds) & ranking_vibrations(Rvibrations) & Rvibrations < Rlight & Rvibrations < Rblinds.

// ranking_option(vibrations) > ranking_option(blinds) & ranking_option(vibrations) > ranking_option(light).

ranking_light(2).
ranking_blinds(1).
ranking_vibrations(0).


!start.

@start_plan
+!start : true <- 
    .print("Starting the plan");
    .wait(3000);
    !manage_wakeup;
    
    !start.

@manage_wakeup_plan
+!manage_wakeup : upcoming_event("now") &  owner_state("awake")<- 
    .print("Enjoy your event").

// task 2.1
+!manage_wakeup : upcoming_event("now") &  owner_state("asleep")<- 
    .print("Starting wake-up routine");
    !wakeup_preference.
    // turnOnLights;
    // raiseBlinds;
    // setVibrationsMode.

@wakeup_preference_plan
+!wakeup_preference : best_option(vibrations) <- 
    setVibrationsMode.
+!wakeup_preference : best_option(blinds) <- 
    raiseBlinds.
+!wakeup_preference : best_option(light) <- 
    turnOnLights.

// +!manage_wakeup : upcoming_event("now") &  owner_state("asleep")<- 
//     .print("Starting wake-up routine");
//     raiseBlinds.

// +!manage_wakeup : upcoming_event("now") &  owner_state("asleep")<- 
//     .print("Starting wake-up routine");
//     setVibrationsMode.

// @ranking_blinds_plan
// +ranking_option(b) : blinds <-
//     .print("The user ranks waking up with artificial light with ", 2).



// the state of the user as monitored by the user’s wristband; 
// e.g., the state of the user being awake or asleep can be represented as: owner_state("awake"), owner_state("asleep");
@owner_state_plan
+owner_state(State) : true <- 
    .print("The owner is ", State).

@upcoming_event_plan
+upcoming_event(Event) : true <- 
    .print("The upcoming event is ", Event).

// the state of the blinds in the room, which can be raised or lowered and represented as: 
// blinds("raised"), blinds("lowered");
@blinds_plan
+blinds(State) : true <- 
    .print("The blinds are ", State).

// the state of the lights in the room, which can be turned on or off 
// and represented as: lights("on"), lights("off");
@lights_plan
+lights(State) : true <- 
    .print("The lights are ", State).

// the state of the user’s mattress which can be in an idle mode or a vibrations mode 
// and represented as: mattress("idle"), mattresss("vibrating").
@mattress_plan
+mattress(State) : true <- 
    .print("The mattress is ", State).

/* Task 2 End of your solution */

/* Import behavior of agents that work in CArtAgO environments */
{ include("$jacamoJar/templates/common-cartago.asl") }