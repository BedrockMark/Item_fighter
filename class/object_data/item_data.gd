### DEPRECATED: Apparently it's a backup, possibly helpful for multi thread - when the day comes...
#class_name ItemData extends ObjectData

@export var throwDamage: float = 0 # negative to heal NOTE: shoot damage belongs to each item: what does it shoot?
@export var stackingQuantity: int = 1 # negative to infinite
## stackException now be hosted by the inventory.
#@export var stackException: Dictionary = {} # NOTE: BOTH name as String OR resource as ItemDate works as key! Int as value for exception!
