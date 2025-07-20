# ==============================================================================
# AttackState.gd - Attack behavior
extends State
class_name AttackState

var attack_timer: float = 0.0
@export var attack_cooldown: float = 1.5
@export var attack_damage_point: float = 0.5 # Time in animation to deal damage
var has_attacked: bool = false

func enter():
	npc.velocity = Vector2.ZERO
	npc.anim_sprite.play("idle_down") # Placeholder for "attack" animation
	attack_timer = 0.0
	has_attacked = false
	if npc.target:
		npc.look_at(npc.target.global_position)

func physics_update(delta: float):
	attack_timer += delta
	
	# Check if target still exists
	if not npc.target:
		state_machine.transition_to("Idle")
		return
	
	var distance = npc.global_position.distance_to(npc.target.global_position)
	
	# Target moved out of range during attack animation
	if distance > npc.attack_range * 1.2: # Use a small buffer
		state_machine.transition_to("Chase")
		return
	
	# Check if should flee
	if npc.get_health_percentage() <= npc.flee_threshold_percent:
		state_machine.transition_to("Flee")
		return
	
	# Execute attack at specific time in animation
	if attack_timer >= attack_damage_point and not has_attacked:
		perform_attack()
		has_attacked = true
	
	# Return to chase after attack cooldown
	if attack_timer >= attack_cooldown:
		state_machine.transition_to("Chase")

func perform_attack():
	# Check if target is still in range and has the take_damage method
	if npc.target and npc.target.has_method("take_damage"):
		if npc.global_position.distance_to(npc.target.global_position) <= npc.attack_range:
			npc.target.take_damage(npc.attack_damage)
			# print(npc.name + " attacked " + npc.target.name + " for " + str(npc.attack_damage) + " damage")
