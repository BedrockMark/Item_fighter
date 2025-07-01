class_name Map extends Node2D

var player := Global.player

func _ready() -> void:
	var timer:=0
	while(player == null):
		timer+=1
		player = Global.player
		assert(timer<=100, "[" + name + "] Map can't load player within 100 times!")

func initiate_player(pos):
	if(player.get_parent()): player.reparent(self)
	else: add_child(player)
	if(pos is Vector2 or pos is Vector2i):
		player.set_position(pos)
	elif(pos is Node):
		player.set_position(pos.position)
	else:
		assert(false, "Player being initiated to unknown spot by " + name)
