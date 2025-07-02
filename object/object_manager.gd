extends Node

var itemDataPath:StringName = "res://data/item/"
var mobDataPath:StringName = "res://data/mob/"
var itemScenePath:StringName = "res://object/item/"
var mobScenePath:StringName = "res://object/mob/"
var itemCategoryConfigPath: StringName = "res://data/item_category.tres"

func load_catergory()->bool:
	return true

func load_data() -> bool:
	# Load Global.itemData
	var itemPaths := DirAccess.get_files_at(itemDataPath)
	var fileCount:=itemPaths.size()
	var importCount :=0
	for path in itemPaths:
		if path.ends_with(".tres"):
			var item = load(itemDataPath + path)
			if item:
				Global.itemData[path.get_basename()] = item
				importCount+=1
	print_debug("Successfully import item data: ", importCount, " out of " , fileCount)
	if(fileCount>importCount): push_error("There're ", fileCount-importCount, " item data FAILED to import!")
	
	importCount = 0
	fileCount = 0
	# Load Global.mobData
	var mobPaths := DirAccess.get_files_at(mobDataPath)
	for path in mobPaths:
		fileCount+=1
		if path.ends_with(".tres"):
			var mob = load(mobDataPath + path)
			if mob:
				Global.mobData[path.get_basename()] = mob
				importCount+=1
	print_debug("Successfully import mob data: ", importCount, " out of ", fileCount)
	if(fileCount>importCount): push_error("There're ", fileCount-importCount, " mob data FAILED to import!")
	return true

func load_object() -> bool:
	# Load Item
	var itemPaths := DirAccess.get_directories_at(itemScenePath)
	var fileCount:=itemPaths.size()
	var importCount :=0
	for path in itemPaths:
		for i in DirAccess.get_files_at(itemScenePath+path):
			if i.ends_with(".tscn"):
				var item = load(itemScenePath + path+"/"+i)
				if item:
					Global.items[path] = item
					importCount+=1
					break
	print_debug("Successfully import item scene: ", importCount, " out of ", fileCount)
	if(fileCount>importCount): push_warning("There're ", fileCount-importCount, " item scenes FAILED to import!")
	
	# Load Mob
	var mobPaths := DirAccess.get_directories_at(mobScenePath)
	fileCount = mobPaths.size()
	importCount = 0
	for path in mobPaths:
		for i in DirAccess.get_files_at(mobScenePath+path):
			if i.ends_with(".tscn"):
				var mob = load(mobScenePath + path+"/"+i)
				if mob:
					Global.mobs[path] = mob
					importCount+=1
					break
	print_debug("Successfully import mob scene: ", importCount, " out of ", fileCount)
	if(fileCount>importCount): push_warning("There're ", fileCount-importCount, " mob scenes FAILED to import!")
	return true


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
