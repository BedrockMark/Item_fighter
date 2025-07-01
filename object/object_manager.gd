extends Node

func load_data() -> bool:
	# Load Global.itemData
	var itemPaths := DirAccess.get_files_at("res://object/data/item/")
	var fileCount:=itemPaths.size()
	var importCount :=0
	for path in itemPaths:
		if path.ends_with(".tres"):
			var item = load("res://object/data/item/" + path)
			if item:
				Global.itemData[path.get_basename()] = item
				importCount+=1
	print_debug("Successfully import item data: ", importCount, " out of " , fileCount)
	if(fileCount>importCount): push_error("There're ", fileCount-importCount, " item data FAILED to import!")
	
	importCount = 0
	fileCount = 0
	# Load Global.mobData
	var mobPaths := DirAccess.get_files_at("res://object/data/mob/")
	for path in mobPaths:
		fileCount+=1
		if path.ends_with(".tres"):
			var mob = load("res://object/data/mob/" + path)
			if mob:
				Global.mobData[path.get_basename()] = mob
				importCount+=1
	print_debug("Successfully import mob data: ", importCount, " out of ", fileCount)
	if(fileCount>importCount): push_error("There're ", fileCount-importCount, " mob data FAILED to import!")
	return true

func load_object() -> bool:
	# Load Item
	var itemPaths := DirAccess.get_directories_at("res://object/item/")
	var fileCount:=itemPaths.size()
	var importCount :=0
	for path in itemPaths:
		for i in DirAccess.get_files_at("res://object/item/"+path):
			if i.ends_with(".tscn"):
				var item = load("res://object/item/" + path+"/"+i)
				if item:
					Global.items[path] = item
					importCount+=1
					break
	print_debug("Successfully import item scene: ", importCount, " out of ", fileCount)
	if(fileCount>importCount): push_warning("There're ", fileCount-importCount, " item scenes FAILED to import!")
	
	# Load Mob
	var mobPaths := DirAccess.get_directories_at("res://object/mob/")
	fileCount = mobPaths.size()
	importCount = 0
	for path in mobPaths:
		for i in DirAccess.get_files_at("res://object/mob/"+path):
			if i.ends_with(".tscn"):
				var mob = load("res://object/mob/" + path+"/"+i)
				if mob:
					Global.mobs[path] = mob
					importCount+=1
					break
	print_debug("Successfully import mob scene: ", importCount, " out of ", fileCount)
	if(fileCount>importCount): push_warning("There're ", fileCount-importCount, " mob scenes FAILED to import!")
	return true
