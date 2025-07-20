class_name Buff extends Resource

@export var level: int = 1: set = _new_level

## Default affected value type -> strength
@export var effect: Dictionary[StringName, float]
## Default affected value type -> strength%
##  NOTE: strength = 10 means add 10%
@export var effect_precent: Dictionary[StringName, float]
@export var effect_override: Dictionary 

## Each level up means doing the following calculations \
## The Vector2 includes: (adder, multiplyer), e.g. "hp"->(5,10%) means that \
## each level will increase the hp property for 5 in value, then 10%
@export var levelUpDataChange: Dictionary[StringName, Vector2]

var target: Node2D ## It should be initiated by _ready function.

func _new_level(value:int):
	##TODO: update effect list
	level = value
