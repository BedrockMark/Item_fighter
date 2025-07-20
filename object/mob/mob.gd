### Mob template, all mobs should extend from this class.
class_name Mob extends CharacterBody2D

#region Core Properties
@export var hp: float = 100.0 ## Current health. hp < 0 to be infinite.
@export var max_hp: float = 100.0 ## Maximum health.
@export var defend: float = 0.0 ## Damage reduction. Negative means extra weak.
@export var speed: float = 150.0 ## Base movement speed.
@export var chase_speed: float = 220.0 ## Speed when chasing a target.
@export var attack_damage: float = 20.0 ## Damage dealt by attacks.
@export var attack_range: float = 40.0 ## Range within which the mob can attack.
@export var detection_range: float = 200.0 ## Range to detect targets.
@export var patrol_points: Array[Vector2] = [] ## Points for patrolling.
@export var return_threshold: float = 400.0  # Distance from origin before returning to patrol.
@export var flee_threshold_percent: float = 0.2  # Flee when health is below this percentage.
#endregion

#region State and Equipment
@export_category("State List")
@export var equipment:Dictionary[StringName, Item] ## NOTE: Inventory will belong to one of the items.
@export var ability:Array[StringName] ## StringName to be the name of the ability function.
@export var buff: Dictionary[String, Buff] ## Also put debuffs here as well.
#endregion

#region Components and Internal State
# Core components for FSM
@onready var state_machine: Node = $StateMachine
@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var detection_area: Area2D = $DetectionArea
@onready var attack_area: Area2D = $AttackArea
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D

# Buffs
var active_property_buffs: Dictionary = {}
var original_property_values: Dictionary = {}
@onready var property_list = get_property_list()

# FSM State
var target: Node2D = null
var patrol_origin: Vector2
var last_known_target_position: Vector2

# Player Control State
var direction := "down"
var state := "idle" # Used for player control animation
var last_direction := Vector2.DOWN
var controlling:=false:
	set(value):
		controlling = value
		if value:
			$Camera2D.enabled = true
			if state_machine and state_machine.has_method("transition_to"):
				state_machine.transition_to("Idle") # Reset FSM when player takes control
		else:
			$Camera2D.enabled = false
			if state_machine and state_machine.has_method("start"):
				state_machine.start() # Start FSM when player relinquishes control
#endregion

#region Signals
signal health_changed(new_health: float)
signal died()
signal target_detected(target: Node2D)
signal target_lost()
#endregion


func _ready() -> void:
	patrol_origin = global_position
	hp = max_hp
	
	if(equipment.has("hand") and equipment["hand"].get_parent()==null):
		$HoldPoint.add_child(equipment["hand"])

	if not controlling:
		_setup_areas()
		if state_machine and state_machine.has_method("start"):
			state_machine.start()
	
	# Connect signals
	health_changed.connect(_on_health_changed)
	died.connect(_on_died)


func _setup_areas():
	if not is_inside_tree():
		await ready
	# Setup detection area
	var detection_shape = CircleShape2D.new()
	detection_shape.radius = detection_range
	detection_area.get_child(0).shape = detection_shape
	detection_area.body_entered.connect(_on_detection_area_entered)
	detection_area.body_exited.connect(_on_detection_area_exited)
	
	# Setup attack area
	var attack_shape = CircleShape2D.new()
	attack_shape.radius = attack_range
	attack_area.get_child(0).shape = attack_shape


func _physics_process(delta: float) -> void:
	if controlling:
		# Player is in control
		var input_vector = Vector2(
			Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
			Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
		).normalized()
		move_mob(input_vector)
		handle_player_actions()
	else:
		# FSM is in control
		# The state machine's _physics_process will set velocity.
		# Animation is handled by each state.
		if velocity.length() > 0:
			anim_sprite.flip_h = velocity.x < 0
	
	move_and_slide()


#region Player Control
# This function is called when the player is controlling the mob.
func move_mob(input_vector:Vector2)->void:
	velocity = input_vector * speed
	
	if input_vector != Vector2.ZERO:
		last_direction = input_vector
		state = "walk"
		_update_walk_animation(input_vector)
	else:
		state = "idle"
		
	if anim_sprite.animation != state+"_"+direction:
		anim_sprite.play(state+"_"+direction)

func _update_walk_animation(d: Vector2):
	if d.y < 0:
		direction = "up"
	elif d.y > 0:
		direction = "down"
	elif d.x < 0:
		direction = "left"
	elif d.x > 0:
		direction = "right"

# Centralized input action handling for player control
func handle_player_actions():
	if Input.is_action_just_pressed("ui_accept"):
		if(equipment.has("hand")): equipment["hand"].use(self)
	if Input.is_action_just_pressed("ui_select"):
		if(equipment.has("hand")): equipment["hand"].alt_use()
	# ... (keep all other player input checks here)
#endregion


#region FSM Utilities
# Utility functions for states to use
func can_see_target(target_node: Node2D) -> bool:
	if not target_node or not is_instance_valid(target_node):
		return false
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(global_position, target_node.global_position)
	query.exclude = [self]
	var result = space_state.intersect_ray(query)
	return result.is_empty() or result.collider == target_node

func move_to_position(target_pos: Vector2, move_speed: float):
	if not navigation_agent.is_target_reachable():
		velocity = Vector2.ZERO
		return
	navigation_agent.target_position = target_pos
	var next_position = navigation_agent.get_next_path_position()
	var direction_to_next = (next_position - global_position).normalized()
	velocity = direction_to_next * move_speed

func get_health_percentage() -> float:
	if max_hp <= 0: return 1.0
	return hp / max_hp
#endregion


#region Health and Buffs
func take_damage(amount: float):
	hp = max(0, hp - (amount - defend))
	health_changed.emit(hp)
	if hp <= 0:
		died.emit()

func heal(amount: float):
	hp = min(max_hp, hp + amount)
	health_changed.emit(hp)

func add_buff(new_buff: Buff):
	if buff.has(new_buff.name):
		remove_buff(buff[new_buff.name])
	buff[new_buff.name] = new_buff
	for key in new_buff.effect:
		if property_list.has(key):
			set(key, get(key) + new_buff.effect[key])
	for key in new_buff.effect_override:
		if not active_property_buffs.has(key):
			active_property_buffs[key] = []
			original_property_values[key] = get(key)
		active_property_buffs[key].append(new_buff)
		set(key, new_buff.effect_override[key])

func remove_buff(buff_to_remove: Buff):
	if not buff.has(buff_to_remove.name):
		return
	for key in buff_to_remove.effect:
		if property_list.has(key):
			set(key, get(key) - buff_to_remove.effect[key])
	for key in buff_to_remove.effect_override:
		if active_property_buffs.has(key):
			var buff_array = active_property_buffs[key]
			buff_array.erase(buff_to_remove)
			if buff_array.is_empty():
				set(key, original_property_values[key])
				active_property_buffs.erase(key)
				original_property_values.erase(key)
			else:
				var last_buff = buff_array.back()
				set(key, last_buff.effect_override[key])
	buff.erase(buff_to_remove.name)
#endregion


#region Signal Handlers
func _on_detection_area_entered(body):
	if body.is_in_group("player") or body.is_in_group("enemies"): # Adjust groups as needed
		if body != self and can_see_target(body):
			target = body
			last_known_target_position = body.global_position
			target_detected.emit(body)

func _on_detection_area_exited(body):
	if body == target:
		target = null # Clear the target
		target_lost.emit()

func _on_health_changed(_new_health: float):
	# Optional: Add visual feedback for health changes, e.g., flashing red
	pass

func _on_died():
	if state_machine and state_machine.has_method("transition_to"):
		state_machine.transition_to("Dead")
#endregion
