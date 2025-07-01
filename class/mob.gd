class_name Mob extends CharacterBody2D

@export var mobData: MobData = null # WARNING: if it's null, it's nothing!!!
@export var inventory: Inventory = null # NOTE: An inventory will be automatically assigned IF there's nothing is manual assigned

func _init(data: MobData = null) -> void:
	if(data == null):
		push_error("No data being added to " + name)
		return
	mobData = data
	if(inventory==null): inventory = Inventory.new(mobData,data.itemCapability)
