# ==============================================================================
# SearchState.gd - Search for lost target
extends State
class_name SearchState

var search_timer: float = 0.0
@export var search_duration: float = 5.0

func enter():
	npc.anim_sprite.play("walk_down") # Placeholder for "walk" or "search" animation
	search_timer = 0.0
	# Move to the last known position first
	npc.move_to_position(npc.last_known_target_position, npc.speed)

func physics_update(delta: float):
	search_timer += delta
	
	# Check if target reappeared
	if npc.target and npc.can_see_target(npc.target):
		state_machine.transition_to("Alert")
		return
	
	# If we reached the destination, stop
	if npc.navigation_agent.is_navigation_finished():
		npc.velocity = Vector2.ZERO
		npc.anim_sprite.play("idle_down")

	# Search timeout
	if search_timer >= search_duration:
		state_machine.transition_to("Return")
		return
