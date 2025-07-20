# ==============================================================================
# DeadState.gd - Death state
extends State
class_name DeadState

var death_timer: float = 0.0
@export var disappear_delay: float = 3.0 # Time before the body disappears

func enter():
	npc.velocity = Vector2.ZERO
	npc.anim_sprite.play("idle_down") # Placeholder for "death" animation
	npc.set_collision_layer_value(1, false)  # Disable collision
	npc.set_collision_mask_value(1, false)
	death_timer = 0.0

func physics_update(delta: float):
	death_timer += delta
	if death_timer >= disappear_delay:
		npc.queue_free() # Remove the mob from the scene
