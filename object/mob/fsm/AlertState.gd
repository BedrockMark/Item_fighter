# ==============================================================================
# AlertState.gd - Alert when enemy detected
extends State
class_name AlertState

var alert_timer: float = 0.0
@export var alert_duration: float = 1.0

func enter():
	npc.velocity = Vector2.ZERO
	npc.anim_sprite.play("idle_down") # Placeholder for an "alert" animation
	alert_timer = 0.0
	if npc.target:
		npc.look_at(npc.target.global_position)


func physics_update(delta: float):
	alert_timer += delta
	
	# Check if target still exists and is visible
	if not npc.target or not npc.can_see_target(npc.target):
		state_machine.transition_to("Search")
		return
	
	# Check if should flee
	if npc.get_health_percentage() <= npc.flee_threshold_percent:
		state_machine.transition_to("Flee")
		return
	
	# After alert duration, start chasing
	if alert_timer >= alert_duration:
		state_machine.transition_to("Chase")
