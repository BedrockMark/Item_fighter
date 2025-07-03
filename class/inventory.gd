class_name Inventory extends Resource

## <=0: zero. Unless infinite storage being supported by a list?
@export var slotCount:Dictionary[ItemCategory, int]
var storage:Dictionary[int, Item] ## Slot number for storage -> item
var stackExpection: Dictionary[StringName, int]## Item ID -> count
## (optional) Who's my dad?
var owner: Node2D = null

func input_item():
	pass

func output_item():
	pass

#func _init(newOwner:Node2D = null, slotAmount:int = 1) -> void:
	#slotCount = slotAmount
	#if(newOwner): owner = newOwner
	#else: push_warning("Inventory " + self.resource_name + "didn't assign a parent!")
