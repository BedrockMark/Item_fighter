### Mob template, most files in this folder should extends from this class.

class_name Mob extends CharacterBody2D

### Constants
@export var hp: float = 100 ## hp < 0 to be infinite
@export var defend: float = 0 ## negative means extra weak
@export var speed: float = 150.0 ## Negative to reverse the actions

### Capabilities
@export var equipment:Array[Item] ## NOTE: Inventory will belong to one of the items, rather than a seperate 
@export var ability:Array[StringName] ## StringName to be the name of the ability function.
@export var buff: Dictionary[String, Buff] ## Also put debuffs here as well.

@onready var anim_sprite = $AnimatedSprite2D

### Backend datas
var direction := "down"
var state := "idle"
var last_direction := Vector2.DOWN

#func _init(data: MobData = null, defaultInventory: Inventory = null) -> void:
	#if(defaultInventory): inventory = defaultInventory

func move_mob(input_vector:Vector2)->void:
	
	velocity = input_vector * speed
	move_and_slide()

	if input_vector != Vector2.ZERO:
		last_direction = input_vector
		state = "walk"
		_update_walk_animation(input_vector)
	else:
		state = "idle"
		
	if anim_sprite.animation != state+"_"+direction:
		anim_sprite.play(state+"_"+direction)
		#print(state+"_"+direction)

func _update_walk_animation(d: Vector2):
	if d.y < 0:
		direction = "up"
	elif d.y > 0:
		direction = "down"
	elif d.x < 0:
		direction = "left"
	elif d.x > 0:
		direction = "right"
