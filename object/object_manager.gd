extends Node

var itemScenePath:StringName = "res://object/item/"
var mobScenePath:StringName = "res://object/mob/"
var itemCategoryPath: StringName = "res://object/item_category/"

func load_category()->bool:
	var catergoryPaths := DirAccess.get_files_at(itemCategoryPath)
	var fileCount:=catergoryPaths.size()
	var importCount :=0
	for path in catergoryPaths:
		if path.ends_with(".tres"):
			var catergory = load(itemCategoryPath + path)
			if catergory is ItemCategory:
				Global.itemCategories[path.get_basename()] = catergory
				importCount+=1
	for key in Global.itemCategories:
		var current = Global.itemCategories[key]
		if(current.parentCategory && Global.itemCategories.has(current.parentCategory)): current.parentCategory.subCategories.append(current)
		else: 
			Global.itemCategories["root"].subCategories.append(current)
			current.parentCategory = Global.itemCategories["root"]
	print_debug("Successfully import catergory: ", importCount, " out of " , fileCount)
	if(fileCount>importCount): push_error("There're ", fileCount-importCount, " catergories FAILED to import!")
	return true

## Load Item
func load_item() -> bool:
	var itemPaths := DirAccess.get_directories_at(itemScenePath)
	var fileCount:=itemPaths.size()
	var importCount :=0
	for path in itemPaths:
		var item_path := itemScenePath+path+"/"+path+".tscn"
		if FileAccess.file_exists(item_path):
			var item = load(item_path)
			Global.items[path] = item
			importCount+=1
		else:
			push_warning("Unable to load item:", item_path)
	print_debug("Successfully import item scene: ", importCount, " out of ", fileCount)
	if(fileCount>importCount): push_warning("There're ", fileCount-importCount, " item scenes FAILED to import!")
	
	## Preprocess: add item to its category's accepted items array & update each item's name
	var tempItems: Dictionary[StringName,Item]
	for i in Global.items:
		var item := Global.items[i].instantiate()
		if item and item is Item: #and item.has_variable("itemCategory"):
			item.itemName = i
			tempItems[i] = item
			if item.itemCategory: item.itemCategory.acceptedItems.append(i)
			else: Global.itemCategories["root"].acceptedItems.append(i)
	
	## Preprocess: Update every scene's accepted items to include its sub category's accepted items
	var currentList:Array[ItemCategory] = []
	var waitList:Array[ItemCategory] = []
	for i in Global.itemCategories:
		var cat := Global.itemCategories[i]
		if cat.subCategories.is_empty(): 
			if cat.parentCategory != Global.itemCategories["root"]: waitList.append(cat.parentCategory)
			cat.parentCategory.acceptedItems.append_array(cat.acceptedItems)
	while not waitList.is_empty():
		if(currentList.is_empty()):
			currentList = waitList.duplicate()
			waitList.clear()
		#var current:ItemCategory=Global.itemCategories[currentList.back()]
		var current:ItemCategory=currentList.pop_back()
		var parent:=current.parentCategory
		if parent:
			if parent != Global.itemCategories["root"]: waitList.append(parent)
			parent.acceptedItems.append_array(current.acceptedItems)
		
	## Preprocess: update each item's acceptedShootingItem array
	for i in tempItems:
		var currentItem := tempItems[i]
		var shootingItemList:=currentItem.acceptedShootingItem
		for j in currentItem.shootingCategory:
			shootingItemList.append_array(j.acceptedItems)
		for j in currentItem.shootingItemExpand:
			shootingItemList.append(j.itemName)
		for j in currentItem.shootingCategoryException:
			for k in j.acceptedItems:
				shootingItemList.erase(k)
		for j in currentItem.shootingItemException:
			shootingItemList.erase(j.itemName)
		## NOTE: I don't think the following unique is necessary, but we'll see...
		#Utility.array_unique(currentItem.acceptedShootingItem)
		Global.items[i] = PackedScene.new()
		Global.items[i].pack(currentItem)
	
	## NOTE: Debug purpose only:
	print("[Object_manager] --- Item loading debug log: ---")
	for i in Global.itemCategories:
		print("Class [",i,"] has the accepted items: ", Global.itemCategories[i].acceptedItems)
	for i in tempItems:
		print("Item [", tempItems[i].itemName, "] has an acceptedShootingItem array of: ", tempItems[i].acceptedShootingItem)
	print("[Object_manager] --- Item loading debug log ends ---")
	return true
	
## Load Mob
func load_mob() -> bool:
	var mobPaths := DirAccess.get_directories_at(mobScenePath)
	var fileCount := mobPaths.size()
	var importCount := 0
	for path in mobPaths:
		var mob_path := mobScenePath + path + "/" + path + ".tscn"
		if FileAccess.file_exists(mob_path):
			var mob = load(mob_path)
			Global.mobs[path] = mob
			importCount+=1
			break
		else:
			push_warning("Unable to load mob:", mob_path)
	print_debug("Successfully import mob scene: ", importCount, " out of ", fileCount)
	if(fileCount>importCount): push_error("There're ", fileCount-importCount, " mob scenes FAILED to import!")
	return true

#func load_data() -> bool:
	## Load Global.itemData
	#var itemPaths := DirAccess.get_files_at(itemDataPath)
	#var fileCount:=itemPaths.size()
	#var importCount :=0
	#for path in itemPaths:
		#if path.ends_with(".tres"):
			#var item = load(itemDataPath + path)
			#if item is ItemData:
				#Global.itemData[path.get_basename()] = item
				#importCount+=1
	#print_debug("Successfully import item data: ", importCount, " out of " , fileCount)
	#if(fileCount>importCount): push_error("There're ", fileCount-importCount, " item data FAILED to import!")
	#
	#importCount = 0
	#fileCount = 0
	## Load Global.mobData
	#var mobPaths := DirAccess.get_files_at(mobDataPath)
	#for path in mobPaths:
		#fileCount+=1
		#if path.ends_with(".tres"):
			#var mob = load(mobDataPath + path)
			#if mob is MobData:
				#Global.mobData[path.get_basename()] = mob
				#importCount+=1
	#print_debug("Successfully import mob data: ", importCount, " out of ", fileCount)
	#if(fileCount>importCount): push_error("There're ", fileCount-importCount, " mob data FAILED to import!")
	#return true
	
#func load_category()->bool:
	## Path check
	#if not FileAccess.file_exists(itemCategoryConfigPath):
		#push_error("Item category path not exist: " + itemCategoryConfigPath)
		#return false
	#
	## File check
	#var file = FileAccess.open(itemCategoryConfigPath, FileAccess.READ)
	#if file == null:
		#push_error("Unable to open the file: " + itemCategoryConfigPath)
		#return false
	#
	#var json_text = file.get_as_text()
	#file.close()
#
	## parse JSON
	#var result = JSON.new().parse(json_text)
	#if result.error != OK:
		#push_error("Unable to parse JSON from file: " + itemCategoryConfigPath + " because " + result.error_string)
		#return false
	### Child -> Parent
	#var parentWaitlist:Dictionary[StringName, StringName] = {} 
	## Save tree to nodes
	#for i in result.result:
		#var nodeName: StringName = parse_value_from_dictionary(i,"Name")
		#var son = pvfd.call(i,"Son")
		#if(son==null): son = []
		#Global.itemCategories[nodeName] = ItemCategory.new(pvfd.call(i,"Icon"),son)
		#for j in son:
			#parentWaitlist[j] = nodeName
	#for son in parentWaitlist:
		#Global.itemCategories[son].parentCategory = parentWaitlist[son]
		#
	#print("Successfully load item category JSON, total catergories = ", Global.itemCategories.size())
	#
	#return true
