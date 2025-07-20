# ==============================================================================
# StunnedState.gd - Stunned when hit
extends State
class_name StunnedState

var stun_timer: float = 0.0
@export var stun_duration: float = 1.0

func enter():
	npc.velocity = Vector2.ZERO
	npc.anim_sprite.play("idle_down") # Placeholder for "stunned" animation
	stun_timer = 0.0

func physics_update(delta: float):
	stun_timer += delta
	
	if stun_timer >= stun_duration:
		# Return to appropriate state based on situation
		if npc.target:
			state_machine.transition_to("Alert")
		else:
			state_machine.transition_to("Idle")
