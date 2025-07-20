# ==============================================================================
# PatrolState.gd - Patrol behavior
extends State
class_name PatrolState

var current_patrol_index: int = 0
@export var patrol_wait_time: float = 1.0
var wait_timer: float = 0.0
var is_waiting: bool = false

func enter():
	npc.anim_sprite.play("walk_down") # Or some default walk animation
	if npc.patrol_points.is_empty():
		state_machine.transition_to("Idle")
		return
	is_waiting = false
	wait_timer = 0.0
	# Move to the first point
	_move_to_patrol_point()

func physics_update(delta: float):
	# Check for targets
	if npc.target:
		state_machine.transition_to("Alert")
		return
	
	if is_waiting:
		wait_timer += delta
		if wait_timer >= patrol_wait_time:
			is_waiting = false
			current_patrol_index = (current_patrol_index + 1) % npc.patrol_points.size()
			_move_to_patrol_point()
	else:
		if not npc.patrol_points.is_empty():
			var target_point = npc.patrol_points[current_patrol_index]
			if npc.global_position.distance_to(target_point) < 10.0:
				npc.velocity = Vector2.ZERO
				is_waiting = true
				npc.anim_sprite.play("idle_" + npc.direction)

func _move_to_patrol_point():
	if not npc.patrol_points.is_empty():
		var target_point = npc.patrol_points[current_patrol_index]
		npc.move_to_position(target_point, npc.speed)
		npc.anim_sprite.play("walk_down") # Needs better animation handling based on direction
