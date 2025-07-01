class_name Inventory extends Resource

## -1 ONLY for infinite
@export var slotCount:int = -1
## Who's my dad?
@export var inventoryType: ObjectData = null 

func _init(parent: MobData, slotAmount:int = 1) -> void:
	slotCount = slotAmount
	if(parent): inventoryType = parent
	else: push_warning("Inventory " + self.resource_name + "didn't assign a parent!")
