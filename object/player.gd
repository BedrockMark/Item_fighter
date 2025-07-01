class_name Player extends Mob

@export var speed: float = 150.0

@onready var anim_sprite = $AnimatedSprite2D
var playerDirection := "down"
var playerState := "idle"
var last_direction := Vector2.DOWN

func _physics_process(delta):
	var input_vector = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	).normalized()

	velocity = input_vector * speed
	move_and_slide()

	if input_vector != Vector2.ZERO:
		last_direction = input_vector
		playerState = "walk"
		_update_walk_animation(input_vector)
	else:
		playerState = "idle"
		
	if anim_sprite.animation != playerState+"_"+playerDirection:
		anim_sprite.play(playerState+"_"+playerDirection)
		print(playerState+"_"+playerDirection)

func _update_walk_animation(direction: Vector2):
	if direction.y < 0:
		playerDirection = "up"
	elif direction.y > 0:
		playerDirection = "down"
	elif direction.x < 0:
		playerDirection = "left"
	elif direction.x > 0:
		playerDirection = "right"
		
