# ==============================================================================
# IdleState.gd - Idle behavior
extends State
class_name IdleState

var idle_timer: float = 0.0
@export var idle_duration: float = 2.0

func enter():
	npc.velocity = Vector2.ZERO
	idle_timer = 0.0
	npc.anim_sprite.play("idle_" + npc.direction)

func physics_update(delta: float):
	idle_timer += delta
	
	# Check for targets
	if npc.target:
		state_machine.transition_to("Alert")
		return
	
	# Transition to patrol after idle time
	if idle_timer >= idle_duration and not npc.patrol_points.is_empty():
		state_machine.transition_to("Patrol")
