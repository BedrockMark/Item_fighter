# ==============================================================================
# State.gd - Base state class
extends Node
class_name State

var state_machine: StateMachine
var npc: Mob

func enter():
	pass

func exit():
	pass

func physics_update(delta: float):
	pass
