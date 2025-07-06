### Scene manager should taking care of scene changing.
### Its job Include but not limited to: load bar, transition etc.
### Its job does NOT include: Player placing (should be realize by arena map scene) or mob summon/action

extends Node2D

func _ready() -> void:
	Global.currentArena = $Map
	## Debug usage only, should be located under ui_manager / arena maps.
	turn_to_map("res://scene/arena/demo.tscn")
	Global.currentArena.summon_item_from_id("demo_item")

func turn_to_map(path:String)->bool:
	var map := load_map(path)
	Global.currentArena.free()
	Global.currentArena =  map.instantiate()
	self.add_child(Global.currentArena)
	return true

func load_map(path:String)->PackedScene:
	if(Global.maps.has(path)): return Global.maps[path]
	Global.maps[path] = load(path)
	return Global.maps[path]
