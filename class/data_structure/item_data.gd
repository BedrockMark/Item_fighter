class_name ItemData extends ObjectData

@export var throwDamage: float = 0 # negative to heal
@export var stackingQuantity: int = 1 # negative to infinite
@export var stackException: Dictionary = {} # NOTE: BOTH name as String OR resource as ItemDate works as key! Int as value for exception!
