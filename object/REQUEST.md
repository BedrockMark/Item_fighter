# TODO
Just in case, if there's a specific function name that you're going to use, pretending it had been 
done, but you're not sure the specific detail of doing that, and you're sure it belong to this manager,
then write down the function and its job in the following list so when we're going to deal that, 
we can have a thought of the proper name/ we can priorotize it.

## Item data request (July 5th)
Up till this point, most fundamental definition of the items are 90% defined (not solid yet), 
although most of them are still on their way to become functional, it could be a good time 
for us to start the design of items. Here're some request for demo items for further debug:
**When you're building items, make sure you're NOT copying the scene, but right click and Create a new inheritance scene!**
- A basic item category tree, maybe include 5-10 categories
- Script-not-required items, spread out to each category (and yes, leave one of the categories blank, I'd like to see what bug that may cause)

## Mob FSM Implementation (July 20th)
Successfully implemented a comprehensive Finite State Machine (FSM) for the `Mob` class, enabling autonomous AI behavior while retaining existing player-control functionality.

### 1. Refactored `object/mob/mob.gd`
- **Dual-Control System:** Modified `_physics_process` to switch between player control and FSM control based on the `controlling` boolean variable. When `controlling` is `false`, the FSM takes over.
- **Integrated AI Properties:** Merged essential AI variables from `monster_fsm.txt` (e.g., `hp`, `speed`, `detection_range`, `target`) into the `Mob` class.
- **Added FSM Components:** Included `@onready` variables for required nodes (`StateMachine`, `DetectionArea`, `AttackArea`, `NavigationAgent2D`).
- **Utility Functions & Signals:** Added helper functions for the FSM states (e.g., `can_see_target`, `move_to_position`) and signal handlers for AI events (`_on_detection_area_entered`, `_on_died`).

### 2. Created FSM Scripts
- **New Directory:** Established a dedicated folder for all FSM-related scripts at `object/mob/fsm/`.
- **Core Scripts:**
    - `StateMachine.gd`: The central controller that manages state transitions.
    - `State.gd`: The base class from which all individual states inherit.
- **State Scripts:** Created a full suite of state scripts based on `monster_fsm.txt`, including `IdleState`, `PatrolState`, `AlertState`, `ChaseState`, `AttackState`, `FleeState`, `DeadState`, and others.

### 3. Scene Setup in `object/mob.tscn`
- Provided detailed instructions for the user to manually update the `mob.tscn` scene in the Godot editor.
- This involved adding the necessary nodes (`StateMachine`, `NavigationAgent2D`, `DetectionArea`, `AttackArea`) and all the individual state nodes as children of the `StateMachine`.
- Instructed on attaching the correct scripts, adding the nodes to the `fsm_state` group, and setting the initial state in the inspector.

The `Mob` class is now equipped with a robust and extensible FSM, allowing for complex AI behaviors in non-player-controlled instances.