// illuminance controller agent

/* Initial rules */

// Inference rule for infering the belief requires_brightening if the target illuminance is higher than the current illuminance
requires_brightening :- target_illuminance(Target) & current_illuminance(Current) & Target > Current & (Target mod (Current+100)) == 0.
// requires_brightening :- (target_illuminance(Target) & current_illuminance(Current) & Target > Current).

// Inference rule for infering the belief requires_darkening if the target illuminance is lower than the current illuminance
requires_darkening :- target_illuminance(Target) & current_illuminance(Current) & Target <= Current & (Target mod (Current+100)) == 0.

// task1.1:1
maintain_illuminance :- target_illuminance(Target) & current_illuminance(Current) & Target = Current.

/* Initial beliefs */

// The agent believes that the target illuminance is 400 lux
target_illuminance(400).

/* Initial goals */

// The agent has the initial goal to start
!start.

/* 
 * Plan for reacting to the addition of the goal !start
 * Triggering event: addition of goal !start
 * Context: true (the plan is always applicable)
 * Body: every 4000ms, the agent strives to maintain the illuminance in the room at the target level 
*/
@start_plan
+!start : true <-
    .print("Continuously managing illuminance");
    .wait(4000);
    !manage_illuminance; // creates the goal !manage_illuminance
    // !manage_blinds;
    !start.


// task1.1: 1
@maintain_illuminance
+!manage_illuminance:  maintain_illuminance <-
    .print("Maintaining the illuminance").

// task1.1: 2
@raise_blinds_with_lights_plan
+!manage_illuminance:  weather("sunny") & blinds("lowered") & requires_brightening <-
    .print("Raising the blinds when it is sunny");
    raiseBlinds.

// task1.1: 3
@lower_blinds_with_weather_plan
+!manage_illuminance:  weather("cloudy") & blinds("raised") <-
    .print("Lowering the blinds when it is cloudy");
    lowerBlinds.

/* 
 * Plan for reacting to the addition of the goal !manage_illuminance
 * Triggering event: addition of goal !manage_illuminance
 * Context: the agent believes that the lights are off and that the room requires brightening
 * Body: the agent performs the action of turning on the lights
*/
@increase_illuminance_with_lights_plan
+!manage_illuminance : lights("off") & requires_brightening <-
    .print("Turning on the lights");
    turnOnLights. // performs the action of turning on the lights

/* 
 * Plan for reacting to the addition of the goal !manage_illuminance
 * Triggering event: addition of goal !manage_illuminance
 * Context: the agent believes that the lights are on and that the room requires darkening
 * Body: the agent performs the action of turning off the lights
*/
@decrease_illuminance_with_lights_plan
+!manage_illuminance:  lights("on") & requires_darkening <-
    .print("Turning off the lights");
    turnOffLights. // performs the action of turning off the lights

/* 
 * Plan for reacting to the addition of the goal !manage_illuminance
 * Triggering event: addition of goal !manage_illuminance
 * Context: the agent believes that the blinds are lowered and that the room requires brightening
 * Body: the agent performs the action of raising the blinds
*/
@increase_illuminance_with_blinds_plan
+!manage_illuminance : blinds("lowered") &  requires_brightening <-
    .print("Raising the blinds");
    raiseBlinds. // performs the action of raising the blinds

/* 
 * Plan for reacting to the addition of the goal !manage_illuminance
 * Triggering event: addition of goal !manage_illuminance
 * Context: the agent believes that the blinds are raised and that the room requires darkening
 * Body: the agent performs the action of lowering the blinds
*/
@decrease_illuminance_with_blinds_plan
+!manage_illuminance:  blinds("raised") & requires_darkening <-
    .print("Lowering the blinds");
    lowerBlinds. // performs the action of lowering the blinds

// task1.1:3
// Write a plan that enables the agent to react to the deletion of the belief weather("sunny") 
// by lowering the blinds if the blinds are currently raised.
// @lower_blinds_with_weather_plan
// +!manage_blinds:  weather("cloudy") & blinds("raised") <-
//     .print("Lowering the blinds when it is cloudy");
//     lowerBlinds.
    
// @lower_blinds_with_weather_plan
// +!manage_blinds:  weather("sunny") & blinds("raised") <-
//     .print("Keep the blind as it is");
//     raiseBlinds.

// @lower_blinds_with_weather_plan
// +!manage_blinds:  weather("cloudy") <-
//     .print("Keep the blind as it is").
/* 
 * Plan for reacting to the addition of the belief current_illuminance(Current)
 * Triggering event: addition of belief current_illuminance(Current)
 * Context: true (the plan is always applicable)
 * Body: prints the current illuminance conditions in the room
*/
@current_illuminance_plan
+current_illuminance(Current) : true <-
    .print("Current illuminance level: ", Current).

/* 
 * Plan for reacting to the addition of the belief weather(State)
 * Triggering event: addition of belief weather(State)
 * Context: true (the plan is always applicable)
 * Body: prints the weather conditions
*/
@weather_plan
+weather(State) : true <-
    .print("The weather is ", State).

/* 
 * Plan for reacting to the addition of the belief blinds(State)
 * Triggering event: addition of belief blinds(State)
 * Context: true (the plan is always applicable)
 * Body: prints the state of the blinds
*/
@blinds_plan
+blinds(State) : true <- 
    .print("The blinds are ", State).

/* 
 * Plan for reacting to the addition of the belief lights(State)
 * Triggering event: addition of belief lights(State)
 * Context: true (the plan is always applicable)
 * Body: prints the state of the lights
*/
@lights_plan
+lights(State) : true <- 
    .print("The lights are ", State).

/* Import behavior of agents that work in CArtAgO environments */
{ include("$jacamoJar/templates/common-cartago.asl") }