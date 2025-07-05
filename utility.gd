### Utility functions, should be general and usable across different files,
extends Node

func snake_to_pascal(snake_str: String) -> String:
	var parts = snake_str.split("_")
	var pascal = ""
	for part in parts:
		pascal += part.capitalize()
	return pascal

func parse_value_from_dictionary(d:Dictionary, key:String):
	if(d.has(key)): return d.get(key)
	elif(d.has(key.substr(0, 1).to_upper() + key.substr(1).to_lower())): return d.get(d.has(key.substr(0, 1).to_upper() + key.substr(1).to_lower()))
	else: return
var pvfd := parse_value_from_dictionary

func array_unique(arr:Array) -> void:
	var seen := {}
	for item in arr:
		if seen.has(item):
			arr.erase(item)
		else:
			seen[item] = true
