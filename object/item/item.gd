class_name Item extends RigidBody2D

var itemName:StringName ## Will be pre-processed by the object manager.
@export var durability: float = 100.0
@export var max_durability: float = 100.0
#@export var throwDamage: float = 0 # negative to heal
@export var muzzleVelocity: float = 1.0
@export var quantity: int = 1: # negative to infinite
	set(value):
		if value: quantity = value
		else: delete_self()
@export var itemCategory: ItemCategory

@export_group("Behavior Definition")
@export var canBeUse:=false ## it can be eat? true. can be drink? true. can be open? true.
@export var effectAsPoision: Array[Buff]
@export var canBeEquiptBy:PackedStringArray ## Type slot names
@export var effectAsPlugin: Array[Buff]
@export var maxPluginCount:int = 0
@export var lossDurabilityWhenDropped:float = 0

@export_group("Texture")
@export var defaultTexture: Texture2D
@export var heldTexture: Texture2D
@export var inventoryIcon: Texture2D

@export_group("State List")
@export var inventory:Inventory
@export var enchantment: Array[Buff]
@export var plugin: Array[Item] ## Items in plugin will be "activate" to add buff on main item.

@export_group("Weapon State")
@export var shootingCategory: Array[ItemCategory]
@export var shootingItemExpand: Array[Item]
@export var shootingCategoryException: Array[ItemCategory]
@export var shootingItemException: Array[Item]
@export_storage var acceptedShootingItem: Array[StringName] ## Preprocessed
var shootingItems: Array[Item] ## backend

var owner_inventory: Inventory ## Preprocessed

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
