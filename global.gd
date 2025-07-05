### All global variables and functions.
### NOTE: I'm being a bit lazy by doing this, that I don't expect it to expand extra large.
### Hopfully, we can navigate through it easily - hopfully

extends Node

### Nodes
var player:Mob = null

### Resource dictionary
var itemCategories: Dictionary[StringName, ItemCategory] = {}

var items: Dictionary[StringName, PackedScene] = {}
var mobs: Dictionary[StringName, PackedScene] = {}
var maps: Dictionary[StringName, PackedScene] = {}

func _ready() -> void:
	ObjectManager.load_category()
	ObjectManager.load_item()
	ObjectManager.load_mob()
	player = load("res://object/mob/mob.tscn").instantiate()
	player.controlling = true

func _physics_process(delta):
	var input_vector = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	).normalized()
	if(player): player.move_mob(input_vector,delta)
