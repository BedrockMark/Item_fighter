class_name Inventory extends Resource

## <=0: zero. Unless infinite storage being supported by a list?
@export var slotCount:Dictionary[ItemCategory, int]
var storage:Dictionary[ItemCategory, Array] ## Slot number for storage -> array[item] (dogot doesn't support nesting type cast, so I didn't write it as Dictionary[ItemCategory,Array[Item]])
var stackExpection: Dictionary[StringName, int]## Item ID -> count, if certain item is in this inventory, it may stack up more than one, otherwise, one will be max quantity
@export var priorityProperty:Dictionary ## Compare the item property in the key of this dicionary (store as StringName) and check if the property of the key has a same value - if is the same, then the priority of this inventory +3
@export var priorityCategory:Array[ItemCategory] ## If an Item's category directly appeared in this array, then priority +3, if is not directly appear, then check if belong to one of the subCategories (check by ItemCategory.subCategory.has([Item's category])), if belong to any, priority +1 
## (optional) Who's my dad?
var owner: Node2D = null

func input_item(item:Item) -> bool:
	# Take the item out of the scene
	if item.get_parent():
		item.get_parent().remove_child(item)

	# Start the recursive search to find the best inventory
	var best_match = _find_best_inventory_recursive(item, {"inventory": null, "priority": -1})

	var target_inventory = best_match["inventory"]

	# If no suitable sub-inventory found, try to place it in this one
	if not target_inventory:
		if _has_space_for(item):
			target_inventory = self
	
	if target_inventory:
		return target_inventory._place_item(item)
	
	# If no inventory could accept the item
	push_warning("No suitable inventory found for item: ", item.name)
	return false

func _find_best_inventory_recursive(item: Item, current_best: Dictionary) -> Dictionary:
	# Calculate priority for the current inventory
	var current_priority = _calculate_priority(item)
	
	# Update best match if current is better and has space
	if current_priority > current_best["priority"] and _has_space_for(item):
		current_best["inventory"] = self
		current_best["priority"] = current_priority

	# Recursively check all sub-container items
	for category in storage:
		for child_item in storage[category]:
			if child_item.inventory: # Check if the item is a container
				current_best = child_item.inventory._find_best_inventory_recursive(item, current_best)
	
	return current_best

func _place_item(item: Item) -> bool:
	var target_category = _get_target_category(item)
	if not target_category:
		return false # Should not happen if _has_space_for was checked

	if not storage.has(target_category):
		storage[target_category] = []
	
	storage[target_category].append(item)
	item.owner_inventory = self
	
	# Connect to the item's tree_exiting signal to auto-remove it
	# Note: This creates a cyclic reference, but Godot's reference counting handles it.
	# For more complex scenarios, consider a weak reference or a signal bus.
	if not item.is_connected("tree_exiting", Callable(self, "_on_item_exiting")):
		item.tree_exiting.connect(Callable(self, "_on_item_exiting").bind(item))
		
	return true

func _on_item_exiting(item: Item):
	remove_item(item)

func _calculate_priority(item: Item) -> int:
	var priority = 0
	# Check category priority
	for category in priorityCategory:
		if item.itemCategory == category:
			priority += 3
			break # Direct match is highest priority
		elif _is_category_or_subcategory(item.itemCategory, category):
			priority += 1
			# Don't break, a more direct subcategory might give higher score later
			# This part of logic might need refinement based on desired behavior
	
	# Check property priority
	for prop_name in priorityProperty:
		if item.has(prop_name) and item.get(prop_name) == priorityProperty[prop_name]:
			priority += 3
			
	return priority

func _has_space_for(item: Item) -> bool:
	var target_category = _get_target_category(item)
	if not target_category:
		return false # This inventory doesn't accept this type of item at all

	var current_count = 0
	if storage.has(target_category):
		current_count = storage[target_category].size()
	
	return current_count < slotCount[target_category]

func _get_target_category(item: Item) -> ItemCategory:
	for category in slotCount.keys():
		if _is_category_or_subcategory(item.itemCategory, category):
			return category
	return null

func _is_category_or_subcategory(child_cat: ItemCategory, parent_cat: ItemCategory) -> bool:
	var current_cat = child_cat
	while current_cat:
		if current_cat == parent_cat:
			return true
		current_cat = current_cat.parentCategory
	return false

func count_item(category: ItemCategory, recursive: bool = false) -> int:
	var count = 0
	if storage.has(category):
		count += storage[category].size()
	
	if recursive:
		for cat in storage:
			for item in storage[cat]:
				if item.inventory:
					count += item.inventory.count_item(category, true)
	return count

func find_item(item_name: StringName, recursive: bool = false) -> Item:
	for category in storage:
		for item in storage[category]:
			if item.name == item_name:
				return item
			if recursive and item.inventory:
				var found = item.inventory.find_item(item_name, true)
				if found:
					return found
	return null

func get_item(item_name: StringName, recursive: bool = false) -> Item:
	var item = find_item(item_name, recursive)
	if item:
		remove_item(item)
	return item

func remove_item(item_to_remove: Item) -> bool:
	if not item_to_remove: return false
	
	for category in storage:
		if storage[category].has(item_to_remove):
			storage[category].erase(item_to_remove)
			item_to_remove.owner_inventory = null
			if item_to_remove.is_connected("tree_exiting", Callable(self, "_on_item_exiting")):
				item_to_remove.tree_exiting.disconnect(Callable(self, "_on_item_exiting"))
			return true
			
	# If not in this inventory, maybe it's in a sub-inventory (though owner_inventory should be correct)
	return false

#func _init(newOwner:Node2D = null, slotAmount:int = 1) -> void:
	#slotCount = slotAmount
	#if(newOwner): owner = newOwner
	#else: push_warning("Inventory " + self.resource_name + "didn't assign a parent!")
