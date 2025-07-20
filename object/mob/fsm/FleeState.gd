# ==============================================================================
# FleeState.gd - Flee when low health
extends State
class_name FleeState

var flee_timer: float = 0.0
@export var max_flee_time: float = 8.0

func enter():
	npc.anim_sprite.play("walk_down") # Placeholder for "run" animation
	flee_timer = 0.0

func physics_update(delta: float):
	flee_timer += delta
	
	# Check if health recovered enough to fight (e.g., by a healing spell)
	if npc.get_health_percentage() > npc.flee_threshold_percent + 0.1:
		state_machine.transition_to("Return")
		return
	
	# Check if fled long enough
	if flee_timer >= max_flee_time:
		state_machine.transition_to("Return")
		return

	# Flee away from target or last known position
	var flee_from_pos = npc.last_known_target_position
	if npc.target:
		flee_from_pos = npc.target.global_position
		
	var flee_direction = (npc.global_position - flee_from_pos).normalized()
	var flee_position = npc.global_position + flee_direction * 200.0 # Flee to a point 200 units away
	npc.move_to_position(flee_position, npc.chase_speed)
