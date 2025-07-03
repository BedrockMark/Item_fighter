class_name Item extends RigidBody2D


@export var inventoryIcon: Texture2D
@export var throwDamage: float = 0 # negative to heal NOTE: shoot damage belongs to each item: what does it shoot?
@export var stackingQuantity: int = 1 # negative to infinite
@export var itemCategory: ItemCategory

func attack():
	pass
