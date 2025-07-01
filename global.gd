### All global variables and functions.
### NOTE: I'm being a bit lazy by doing this, that I don't expect it to expand extra large.
### Hopfully, we can navigate through it easily - hopfully

class_name global extends Node

### Nodes
var player:Mob = null

### Resource dictionary
var itemData: Dictionary[String, ItemData] = {}
var mobData: Dictionary[String, MobData] = {}
var items: Dictionary[String, ItemData] = {}
var mobs: Dictionary[String, MobData] = {}
var maps: Dictionary[String, PackedScene] = {}

func _ready() -> void:
	player = load("res://object/mob.tscn").instantiate()

func _physics_process(_delta):
	var input_vector = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	).normalized()
	if(player): player.move_mob(input_vector)

func load_data() -> bool:
	# Load ItemData
	var item_paths = DirAccess.get_files_at("res://object/data/item/")
	for path in item_paths:
		if path.ends_with(".tres"):
			var item = load("res://data/items/" + path)
			if item:
				itemData[path] = item
	# Load MobData
	var mob_paths = DirAccess.get_files_at("res://object/data/mob/")
	for path in mob_paths:
		if path.ends_with(".tres"):
			var mob = load("res://data/mobs/" + path)
			if mob:
				mobData[path] = mob
	return true

func load_object() -> bool:
	return true

func load_map(path:String)->PackedScene:
	if(maps.has(path)): return maps[path]
	maps[path] = load(path)
	return maps[path]
