### Mob constants - how many weapon it may hold, backpack slot, hp etc.
### NOT about its current state (buffed/upgraded) or its function (move/attack/ability)

class_name MobData extends ObjectData

@export var hp: float = 100 ## hp < 0 to be infinite
### Constants
@export var defend: float = 0 ## negative means extra weak
@export var speed: float = 150.0 ## Negative to reverse the actions

### Capabilities
@export_category("Capability")
@export var weaponCapability:int = 1 ## how many weapon this mob can hold, negative for infinite
@export var abilityCapability:int = 0 ## how many ability this mob can hold, negative for infinite
