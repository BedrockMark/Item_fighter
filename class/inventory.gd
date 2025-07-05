class_name Inventory extends Resource

## <=0: zero. Unless infinite storage being supported by a list?
@export var slotCount:Dictionary[ItemCategory, int]
var storage:Dictionary[int, Item] ## Slot number for storage -> item
var stackExpection: Dictionary[StringName, int]## Item ID -> count
## (optional) Who's my dad?
var owner: Node2D = null

func input_item(item:Item):
	## Unparent, or remove it from the scene, if an item was in a scene
	if item.get_parent(): item.get_parent().remove_child(item)
	## Check if any of its child item has an inventory accept the item
	## TODO: It's kind of disputing, we might discuss it later?
	pass

func output_item():
	pass

#func _init(newOwner:Node2D = null, slotAmount:int = 1) -> void:
	#slotCount = slotAmount
	#if(newOwner): owner = newOwner
	#else: push_warning("Inventory " + self.resource_name + "didn't assign a parent!")
