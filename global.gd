### All global variables and functions.
### NOTE: I'm being a bit lazy by doing this, that I don't expect it to expand extra large.
### Hopfully, we can navigate through it easily - hopfully

class_name global extends Node

### Nodes
var player:Mob = null

### Resource dictionary
var itemData: Dictionary[StringName, ItemData] = {}
var mobData: Dictionary[StringName, MobData] = {}

var items: Dictionary[StringName, PackedScene] = {}
var mobs: Dictionary[StringName, PackedScene] = {}
var maps: Dictionary[StringName, PackedScene] = {}

func _ready() -> void:
	player = load("res://object/mob/mob.tscn").instantiate()
	ObjectManager.load_data()
	ObjectManager.load_object()

func _physics_process(_delta):
	var input_vector = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	).normalized()
	if(player): player.move_mob(input_vector)

func load_map(path:String)->PackedScene:
	if(maps.has(path)): return maps[path]
	maps[path] = load(path)
	return maps[path]
