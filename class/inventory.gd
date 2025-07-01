class_name Inventory extends Resource

## -1 ONLY for infinite
@export var slotCount:int = -1
## Who's my dad?
var owner: Node2D = null 

func _init(newOwner:Node2D = null, slotAmount:int = 1) -> void:
	slotCount = slotAmount
	if(newOwner): owner = newOwner
	else: push_warning("Inventory " + self.resource_name + "didn't assign a parent!")
