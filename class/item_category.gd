### Item category class.
### NOTE: name of the category should be stored in the Global.itemCategories as keys.
class_name ItemCategory extends Resource

@export var icon: Texture2D = null ## This can leave to blank
@export var placeholderIcon: Texture2D = null ## This can leave to blank
@export var inventoryColor: Color = Color.ANTIQUE_WHITE
@export var parentCategory: ItemCategory
var subCategories: Array[ItemCategory] = [] ## load_category() will do this for us.
var acceptedItems: PackedStringArray = [] ## load_category() will do this for us.

#func _init(i:Texture2D,s: Array[StringName] = [], p: StringName = "") -> void:
	#if(i): icon = i
	#else: i = preload("res://asset/ui/placeholder_icon.tres")
	#if(s): subCategories = s
	#if(p): parentCategory = p
