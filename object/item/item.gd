class_name Item extends RigidBody2D

@export var durability: float = 100.0
@export var max_durability: float = 100.0
@export var throwDamage: float = 0 # negative to heal NOTE: shoot damage belongs to each item: what does it shoot?
@export var quantity: int = 1: # negative to infinite
	set(value):
		if value: quantity = value
		else: delete_self()
@export var itemCategory: ItemCategory

@export_group("Texture")
@export var defaultTexture: Texture2D
@export var heldTexture: Texture2D
@export var inventoryIcon: Texture2D

@export_group("State List")
@export var inventory:Inventory
@export var enchantment: Array[Buff]

@export_group("Weapon State")
@export var shootingCategory: Array[ItemCategory]
@export var shootingItemExpand: Array[Item]
@export var shootingCategoryException: Array[ItemCategory]
@export var shootingItemException: Array[Item]
var acceptedShootingItem: Array[StringName]
var shootingItems: Array[Item]

var owner_inventory: Inventory

func _enter_tree() -> void:
	if(get_parent() && get_parent() is Marker2D && heldTexture): 
		## TODO: possible hold item effect/sound
		$Sprite2D.texture = heldTexture
	else: $Sprite2D.texture = defaultTexture

func _exit_tree() -> void:
	$Sprite2D.texture = defaultTexture

## NOTE: DO NOT directly queue free an item! This can break inventory functions!
func delete_self()->void:
	if owner_inventory: owner_inventory.storage.erase(owner_inventory.storage.find_key(self))
	queue_free()

func add_item(item:Item):
	if inventory: inventory.input_item(item)
	else: printerr("Trying to put ", item.name, " into ", name, ", but it doesn't has an inventory!")

func attack():
	pass
