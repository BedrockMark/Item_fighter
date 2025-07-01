### Scene manager should taking care of scene changing.
### Its job Include but not limited to: load bar, transition etc.
### Its job does NOT include: Player placing (should be realize by arena map scene) or mob summon/action

extends Node2D

var currentArena:Node2D = null

func _ready() -> void:
	currentArena = $Map
	#turn_to_map("res://scene/arena/demo.tscn")

func turn_to_map(path:String)->bool:
	var map := Global.load_map(path)
	currentArena.free()
	currentArena =  map.instantiate()
	self.add_child(currentArena)
	return true
