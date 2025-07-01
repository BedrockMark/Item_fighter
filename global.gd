### All global variables and functions.
### NOTE: I'm being a bit lazy by doing this, that I don't expect it to expand extra large.
### Hopfully, we can navigate through it easily - hopfully

class_name global extends Node

### Nodes
var player:Mob = null

### Resource dictionary
var itemData: Dictionary[String, ItemData] = {}
var mobData: Dictionary[String, MobData] = {}

var items: Dictionary[String, PackedScene] = {}
var mobs: Dictionary[String, PackedScene] = {}
var maps: Dictionary[String, PackedScene] = {}

func _ready() -> void:
	player = load("res://object/mob/mob.tscn").instantiate()
	load_data()
	load_object()

func _physics_process(_delta):
	var input_vector = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	).normalized()
	if(player): player.move_mob(input_vector)

func load_data() -> bool:
	# Load ItemData
	var itemPaths := DirAccess.get_files_at("res://object/data/item/")
	var fileCount:=itemPaths.size()
	var importCount :=0
	for path in itemPaths:
		if path.ends_with(".tres"):
			var item = load("res://object/data/item/" + path)
			if item:
				itemData[path.get_basename()] = item
				importCount+=1
	print_debug("Successfully import item data: ", importCount, "from ", fileCount)
	if(fileCount>importCount): push_error("There're ", fileCount-importCount, " item data FAILED to import!")
	
	importCount = 0
	fileCount = 0
	# Load MobData
	var mobPaths := DirAccess.get_files_at("res://object/data/mob/")
	for path in mobPaths:
		fileCount+=1
		if path.ends_with(".tres"):
			var mob = load("res://object/data/mob/" + path)
			if mob:
				mobData[path.get_basename()] = mob
				importCount+=1
	print_debug("Successfully import mob data: ", importCount, "from ", fileCount)
	if(fileCount>importCount): push_error("There're ", fileCount-importCount, " mob data FAILED to import!")
	return true

func load_object() -> bool:
	# Load Item
	var itemPaths := DirAccess.get_directories_at("res://object/item/")
	var fileCount:=itemPaths.size()
	var importCount :=0
	for path in itemPaths:
		for i in DirAccess.get_files_at("res://object/item/"+path):
			if i.ends_with(".tscn"):
				var item = load("res://object/item/" + path+"/"+i)
				if item:
					items[path] = item
					importCount+=1
					break
	print_debug("Successfully import item scene: ", importCount," out of ", fileCount)
	if(fileCount>importCount): push_warning("There're ", fileCount-importCount, " item scenes FAILED to import!")
	
	# Load Mob
	var mobPaths := DirAccess.get_directories_at("res://object/mob/")
	fileCount = mobPaths.size()
	importCount = 0
	for path in mobPaths:
		for i in DirAccess.get_files_at("res://object/mob/"+path):
			if i.ends_with(".tscn"):
				var mob = load("res://object/mob/" + path+"/"+i)
				if mob:
					mobs[path] = mob
					importCount+=1
					break
	print_debug("Successfully import mob scene: ", importCount," out of ", fileCount)
	if(fileCount>importCount): push_warning("There're ", fileCount-importCount, " mob scenes FAILED to import!")
	return true

func load_map(path:String)->PackedScene:
	if(maps.has(path)): return maps[path]
	maps[path] = load(path)
	return maps[path]
