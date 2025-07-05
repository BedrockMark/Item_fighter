class_name Map extends Node2D

@export var enemySummonFrequent: float ##TODO: give it a better name/definition! This is just a placeholder

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

func summon_item_from_node(item:Item, pos:Vector2 = Vector2(0,0))->void:
	item.set_position(pos)
	if(item.get_parent()): 
		item.reparent(self)
	else: add_child(item)

func summon_item_from_id(item:StringName, pos:Vector2 = Vector2(0,0))->void:
	if(Global.items.has(item)): 
		var newItem = Global.items[item].instantiate()
		newItem.set_position(pos)
		add_child(newItem)
	else: printerr("[Map.gd-summon_item] item ", item, " does not exist!")

func switch_player(mob:Mob):
	if player: player.controlling = false
	player = mob
	player.controlling = true
