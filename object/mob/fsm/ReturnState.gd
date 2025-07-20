# ==============================================================================
# ReturnState.gd - Return to patrol origin
extends State
class_name ReturnState

func enter():
	npc.anim_sprite.play("walk_down")
	npc.target = null # Make sure target is cleared
	npc.move_to_position(npc.patrol_origin, npc.speed)

func physics_update(delta: float):
	# Check for new targets on the way back
	if npc.target:
		state_machine.transition_to("Alert")
		return
	
	# Check if reached patrol origin
	if npc.global_position.distance_to(npc.patrol_origin) < 10.0:
		state_machine.transition_to("Idle")
