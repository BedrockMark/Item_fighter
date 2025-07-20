# ==============================================================================
# SleepState.gd - Sleep during day (for nocturnal monsters)
extends State
class_name SleepState

# This is a placeholder state. The logic for when to sleep
# would need to be implemented (e.g., based on a global day/night cycle).

func enter():
	npc.velocity = Vector2.ZERO
	npc.anim_sprite.play("idle_down") # Placeholder for "sleep" animation

func physics_update(delta: float):
	# Example condition to wake up
	# if GlobalTime.is_night():
	# 	state_machine.transition_to("Idle")
	
	# Wake up if attacked
	if npc.get_health_percentage() < 1.0:
		state_machine.transition_to("Alert")
