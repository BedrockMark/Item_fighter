# ==============================================================================
# ChaseState.gd - Chase target
extends State
class_name ChaseState

var last_seen_timer: float = 0.0
@export var max_last_seen_time: float = 3.0

func enter():
	npc.anim_sprite.play("walk_down") # Placeholder for "run" animation
	last_seen_timer = 0.0

func physics_update(delta: float):
	# Check if target still exists
	if not npc.target:
		state_machine.transition_to("Return")
		return
	
	# Check if should flee
	if npc.get_health_percentage() <= npc.flee_threshold_percent:
		state_machine.transition_to("Flee")
		return
	
	# Check if can see target
	if npc.can_see_target(npc.target):
		npc.last_known_target_position = npc.target.global_position
		last_seen_timer = 0.0
		
		# Check if in attack range
		var distance = npc.global_position.distance_to(npc.target.global_position)
		if distance <= npc.attack_range:
			state_machine.transition_to("Attack")
			return
	else:
		last_seen_timer += delta
		# Lost target for too long
		if last_seen_timer >= max_last_seen_time:
			state_machine.transition_to("Search")
			return
	
	# Check if too far from patrol origin
	var distance_from_origin = npc.global_position.distance_to(npc.patrol_origin)
	if distance_from_origin > npc.return_threshold:
		state_machine.transition_to("Return")
		return

	# Move towards the last known position
	npc.move_to_position(npc.last_known_target_position, npc.chase_speed)
