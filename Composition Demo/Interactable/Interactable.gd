class_name Interactable extends Area3D

@onready var highlighter = $Highlighter


# These colliders will be ignored by the line of sight raycast
@export var line_of_sight_exceptions:Array[NodePath]
@export var prompt_text = "Interact"
@export var require_line_of_sight = true
@export var interact_action = "ui_interact"
@export var interact_function = "interact"

var player:CharacterBody3D = null
var active = false



func _ready() -> void:
	add_to_group("Interactable")
	deactivate()
	

# Called by Interaction Manager
func activate():
	active = true
	
	
# Called by Interaction Manager
func deactivate():
	active = false
	set_highlighter_visibility(false)
	

func _on_body_entered(body: CharacterBody3D) -> void:
	player = body
	InteractableManager.add_interactable_in_range(self)
	

func _on_body_exited(_body: CharacterBody3D) -> void:
	player = null
	InteractableManager.erase_interactable_in_range(self)
	

func player_is_in_line_of_sight() -> bool:
	if !require_line_of_sight:
		return true
		
	if player != null:
		var space_state := get_world_3d().direct_space_state
		
		var exceptions = []
		for nodePath in line_of_sight_exceptions:
			exceptions.append(get_node(nodePath))
		
		var params = PhysicsRayQueryParameters3D.create(
		global_position, 
		player.global_position, 
		player.collision_mask, 
		exceptions)
		
		var result := space_state.intersect_ray(params)
		if result == {}:
			return true
			
	return false
	

# Returns true if the object is currently interactable.
func is_interactable() -> bool:
	if get_parent().has_method("is_interactable"):
		return get_parent().is_interactable()
	else:
		printerr("please implement an 'is_interactable' method for: " + str(get_parent().name))
		return false


# Triggers the interaction.
func trigger_interaction() -> void:
	if get_parent().has_method(interact_function) and active:
		get_parent().call(interact_function)
		
	else:
		printerr("Please implement the method '" + interact_function + "' for: " + str(get_parent().name))

func set_highlighter_visibility(value: bool) -> void:
	highlighter.visible = value
