# ==============================================================================
# StateMachine.gd - Central state machine controller
extends Node
class_name StateMachine

@export var initial_state: Node
var current_state: Node
var states: Dictionary = {}
var npc: Mob # Reference to the parent Mob

func _ready():
	# Wait for child states to be ready
	await get_tree().process_frame
	
	npc = get_parent()
	
	# Register all child states
	for child in get_children():
		if child.is_in_group("fsm_state"):
			states[child.name] = child
			child.state_machine = self
			child.npc = npc

func start():
	if initial_state:
		transition_to(initial_state.name)

func transition_to(state_name: StringName):
	if state_name in states:
		var new_state = states[state_name]
		
		if current_state:
			current_state.exit()
		
		current_state = new_state
		current_state.enter()
		# print(npc.name + " transitioned to: " + state_name) # Optional: for debugging

func _physics_process(delta):
	if current_state:
		current_state.physics_update(delta)
