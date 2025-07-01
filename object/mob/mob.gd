### Mob template, most files in this folder should extends from this class.

class_name Mob extends CharacterBody2D

@export var mobData: MobData = null # WARNING: if it's null, it's nothing!!!
@export var defaultMobData: MobData = null # NOTE: it's an optional data, which can be use to determine its origional data.
@export var inventory: Inventory = null # NOTE: An inventory will be automatically assigned IF there's nothing is manual assigned
@export var buff: Dictionary[String, Buff]

@onready var anim_sprite = $AnimatedSprite2D

### Backend datas
var playerDirection := "down"
var playerState := "idle"
var last_direction := Vector2.DOWN

func _init(data: MobData = null, defaultInventory: Inventory = null) -> void:
	if(data == null): push_warning("No data being added to " + name + ", set to defalt!")
	else: mobData = data
	if(defaultInventory): inventory = defaultInventory

func  _ready() -> void:
	if(inventory == null): inventory = Inventory.new(self,mobData.itemCapability)

func move_mob(input_vector:Vector2)->void:
	assert(mobData, "Unable to move mob with null data!")
	
	velocity = input_vector * mobData.speed
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
