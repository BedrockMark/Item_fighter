### All global variables and functions.
### NOTE: I'm being a bit lazy by doing this, that I don't expect it to expand extra large.
### Hopfully, we can navigate through it easily - hopfully

class_name global extends Node

### Nodes
var player:Player = null

### Resource dictionary
var items: Dictionary[String, ItemData] = {}
var mobs: Dictionary[String, MobData] = {}
var maps: Dictionary[String, PackedScene] = {}

func _ready() -> void:
	player = load("res://object/player.tscn").instantiate()

func load_data() -> bool:
	# Load ItemData
	var item_paths = DirAccess.get_files_at("res://object/data/item/")
	for path in item_paths:
		if path.ends_with(".tres"):
			var item = load("res://data/items/" + path)
			if item:
				items[path] = item

	# Load MobData
	var mob_paths = DirAccess.get_files_at("res://object/data/mob/")
	for path in mob_paths:
		if path.ends_with(".tres"):
			var mob = load("res://data/mobs/" + path)
			if mob:
				mobs[path] = mob
	return true

func load_map(path:String)->PackedScene:
	if(maps.has(path)): return maps[path]
	maps[path] = load(path)
	return maps[path]
