class_name Item extends RigidBody2D

var itemName:StringName ## Will be pre-processed by the object manager.
@export var durability: float = 100.0:
	set(value):
		durability = clamp(value, 0, max_durability)
		if durability == 0:
			delete_self()
@export var max_durability: float = 100.0
@export var muzzleVelocity: float = 1.0
@export var quantity: int = 1:
	set(value):
		if value > 0: quantity = value
		else: delete_self()
@export var itemCategory: ItemCategory

@export_group("Behavior Definition")
@export var canBeUse:=false
@export var effectAsPoision: Array[Buff]
@export var canBeEquiptBy:PackedStringArray
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
@export var plugin: Array[Item]

var active_property_buffs: Dictionary = {}
var original_property_values: Dictionary = {}

@export_group("Weapon State")
@export var shootingCategory: Array[ItemCategory]
@export var shootingItemExpand: Array[Item]
@export var shootingCategoryException: Array[ItemCategory]
@export var shootingItemException: Array[Item]
@export_storage var acceptedShootingItem: Array[StringName]
var shootingItems: Array[Item]

var owner_inventory: Inventory
var owner_mob: Mob

@onready var property_list = get_property_list()

func _enter_tree() -> void:
	if get_parent() is Marker2D and heldTexture:
		$Sprite2D.texture = heldTexture
	else:
		$Sprite2D.texture = defaultTexture

func _exit_tree() -> void:
	$Sprite2D.texture = defaultTexture
	if owner:
		unequipt()

func delete_self()->void:
	if owner_inventory:
		owner_inventory.storage.erase(owner_inventory.storage.find_key(self))
	if owner:
		unequipt()
	for p in plugin:
		remove_plugin(p)
	queue_free()

func add_item(item:Item):
	if inventory:
		inventory.input_item(item)
	else:
		printerr("Trying to put ", item.name, " into ", name, ", but it doesn't has an inventory!")

func attack():
	if owner:
		# Implement melee attack logic here
		# For example, check for bodies in an area and apply damage
		for body in $AttackArea.get_overlapping_bodies():
			if body is Mob and body != owner:
				# Apply damage logic from item's properties or buffs
				pass
	pass

func shoot_bullet() -> void:
	var bullet_to_shoot: Item = null

	# 1. Find a suitable bullet from inventory or expanded list
	if inventory and not inventory.storage.is_empty():
		for i in inventory.storage.size():
			var item_in_slot = inventory.storage.get(i)
			if _is_valid_ammo(item_in_slot):
				bullet_to_shoot = item_in_slot
				break
	
	if not bullet_to_shoot and not shootingItemExpand.is_empty():
		for item_in_expand in shootingItemExpand:
			if _is_valid_ammo(item_in_expand):
				bullet_to_shoot = item_in_expand
				break

	if not bullet_to_shoot:
		push_warning("No suitable ammo found for ", name)
		return

	# 2. Instantiate and shoot the bullet
	var bullet_instance = bullet_to_shoot.duplicate() # Use duplicate to create a new instance
	get_tree().current_scene.add_child(bullet_instance)
	bullet_instance.global_position = global_position
	
	var direction = (get_global_mouse_position() - global_position).normalized()
	bullet_instance.rotation = direction.angle()
	bullet_instance.linear_velocity = direction * muzzleVelocity
	
	# 3. Consume the bullet
	bullet_to_shoot.quantity -= 1
	
	# 4. Reduce durability
	durability -= 1

func _is_valid_ammo(item: Item) -> bool:
	if not item: return false
	
	var category_match = false
	if shootingCategory.is_empty():
		category_match = true
	else:
		for category in shootingCategory:
			if item.itemCategory == category:
				category_match = true
				break
	
	var category_exception_match = false
	for category in shootingCategoryException:
		if item.itemCategory == category:
			category_exception_match = true
			break
			
	var item_exception_match = false
	if shootingItemException.has(item):
		item_exception_match = true

	return category_match and not category_exception_match and not item_exception_match

func equipt(new_owner: Mob):
	if not canBeEquiptBy.has(new_owner.name):
		return
	
	owner = new_owner
	# Apply buffs to owner
	for buff in effectAsPlugin:
		# Assuming owner has a method to apply buffs
		owner.add_buff(buff)
	for p in plugin:
		for buff in p.effectAsPlugin:
			owner.add_buff(buff)

func unequipt():
	if owner:
		# Remove buffs from owner
		for buff in effectAsPlugin:
			owner.remove_buff(buff)
		for p in plugin:
			for buff in p.effectAsPlugin:
				owner.remove_buff(buff)
		owner = null

func use(user: Mob):
	if canBeUse:
		for buff in effectAsPoision:
			user.add_buff(buff) # Assuming user has a method to apply buffs
		quantity -= 1

func add_plugin(item_plugin: Item) -> bool:
	if plugin.size() < maxPluginCount:
		plugin.append(item_plugin)
		if owner:
			# Apply plugin buffs to owner
			for buff in item_plugin.effectAsPlugin:
				owner.add_buff(buff)
		return true
	return false

func remove_plugin(item_plugin: Item) -> bool:
	if plugin.has(item_plugin):
		if owner:
			# Remove plugin buffs from owner
			for buff in item_plugin.effectAsPlugin:
				owner.remove_buff(buff)
		plugin.erase(item_plugin)
		return true
	return false

func add_buff(new_buff: Buff):
	if enchantment.has(new_buff):
		remove_buff(new_buff)

	enchantment.append(new_buff)
	
	# Apply numerical effects
	for key in new_buff.effect:
		if property_list.has(key):
			set(key, get(key) + new_buff.effect[key])
			
	# Apply override effects
	for key in new_buff.effect_override:
		if not active_property_buffs.has(key):
			active_property_buffs[key] = []
			original_property_values[key] = get(key)
		
		active_property_buffs[key].append(new_buff)
		set(key, new_buff.effect_override[key])

func remove_buff(buff_to_remove: Buff):
	if not enchantment.has(buff_to_remove):
		return

	# Remove numerical effects
	for key in buff_to_remove.effect:
		if property_list.has(key):
			set(key, get(key) - buff_to_remove.effect[key])
			
	# Remove override effects
	for key in buff_to_remove.effect_override:
		if active_property_buffs.has(key):
			var buff_array = active_property_buffs[key]
			buff_array.erase(buff_to_remove)
			
			if buff_array.is_empty():
				# No other buffs affecting this property, restore original value
				set(key, original_property_values[key])
				active_property_buffs.erase(key)
				original_property_values.erase(key)
			else:
				# Another buff is still active, apply its effect
				var last_buff = buff_array.back()
				set(key, last_buff.effect_override[key])

	enchantment.erase(buff_to_remove)
