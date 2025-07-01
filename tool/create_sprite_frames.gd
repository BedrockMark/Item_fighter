@tool extends EditorScript

## Automatic SpriteFrame2D Generator wrote by Mark
## Guide: Copy path to the following path_to_png variable
## Then run the file (through left_up corner of the SCRIPT WINDOW)
## You should then get an animation_frame resource with same name at same folder - make sure NO pre-made/same name .tres file.

const path_to_png: StringName = "res://asset/character/Premade_Character_32x32_01.png"

## Here starts the script code

var single_sprite_size: Vector2i = Vector2i(32,64)
var animation_catagories: Array[String] = ["idle", "walk","pick","gift","lift","throw","hit","give","grab_weapon","hold_weapon","shot","hurt"]
var dirs: Array[String] = ["right", "up", "left", "down"]
var y_inits: Array = [1,2,9,10,11,12,13,14,16,17,18,19]
var frame_count: Array[int] = [6,6,12,10,14,14,6,6,4,6,3,3]

func _run() -> void:
	var new_res = SpriteFrames.new()
	new_res.remove_animation("default")
	
	var img_tex = load(path_to_png)
	
	var x = 0
	var y = 0
	
	y_inits=y_inits.map(func(value): return value * single_sprite_size.y)
	
	for i in animation_catagories.size():
		x = 0
		y = y_inits[i]
		print(y)
		for j in dirs:
			var new_name = animation_catagories[i]+"_"+j
			new_res.add_animation(new_name)
			for k in frame_count[i]:
				var new_atlas = AtlasTexture.new()
				new_atlas.set_atlas(img_tex)
				new_atlas.region = Rect2i(x,y,single_sprite_size.x,single_sprite_size.y)
				new_res.add_frame(new_name,new_atlas)
				x+=single_sprite_size.x
	
	ResourceSaver.save(new_res, path_to_png.get_base_dir() + "/" +path_to_png.get_file().left(path_to_png.get_file().length()-path_to_png.get_extension().length()-1)+".tres")
	print(path_to_png.get_base_dir() + "/" +path_to_png.get_file().left(path_to_png.get_file().length()-path_to_png.get_extension().length()-1)+".tres")
	EditorInterface.get_resource_filesystem().scan()
