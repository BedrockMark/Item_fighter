class_name Buff extends Resource

@export var level: int = 1: set = _new_level

## Default affected value type -> strength
@export var effect: Dictionary[StringName, float]
## Default affected value type -> strength%
##  NOTE: strength = 10 means add 10%
@export var effect_precent: Dictionary[StringName, float] 

## Each level up means doing the following calculations
## The Vector2 includes: (adder, multiplyer), e.g. "hp"->(5,10%) means th
@export var levelUpDataChange: Dictionary[StringName, Vector2]

func _new_level(value:int):
	##TODO: update effect list
	level = value
