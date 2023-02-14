class_name Interactable extends Area3D

@onready var highlighter := $Highlighter

# TODO: replace this with Array[PhysicsBody3D] when 
# https://github.com/godotengine/godot/issues/66698 is fixed
## These colliders will be ignored by the line of sight raycast
@export var line_of_sight_exceptions:Array[NodePath]
@export var prompt_text := "Interact"
@export var require_line_of_sight := true
@export var interact_action := "ui_interact"

## The function that gets called if the interact action is pressed
@export var interact_function := "interact"

var player = null
var active := false

## if disabled, "is_interactable" will always return false
var disabled := false


func _ready() -> void:
	add_to_group("Interactable")
	deactivate()
	# TODO: when Array[NodePath] is replaced with Array[PhysicsBody3D], this won't be
	# necessary anymore
	if OS.is_debug_build():
		for index in line_of_sight_exceptions.size():
			var node_path := line_of_sight_exceptions[index]
			assert(node_path != null and not node_path.is_empty(), "node %s is null"%[index])
			assert(get_node(node_path) is PhysicsBody3D, "Node %s is not a PhysicsBody3D"%[node_path])



## If active, this interactable is currently able to be interacted with.
## Called by Interaction Manager.
func activate() -> void:
	active = true
	
	
## Called by Interaction Manager
func deactivate() -> void:
	active = false
	set_highlighter_visibility(false)
	

func disable() -> void:
	disabled = true
	

## When the player is in range, add this interactable to the list of interactables in range.
func _on_body_entered(body: CharacterBody3D) -> void:
	player = body
	InteractableManager.add_interactable_in_range(self)
	
	
## When the player is no longer in range, remove this interactable from the list of interactables in range.
func _on_body_exited(_body: CharacterBody3D) -> void:
	player = null
	InteractableManager.erase_interactable_in_range(self)
	

## Without checking if the player is in line of sight, you could interact
#	with interactables through solid objects, like walls for example.
func player_is_in_line_of_sight() -> bool:
	
	# if line of sight is not required, return true regardless
	if not require_line_of_sight:
		return true
		
	# Shoot a raycast from this interactables position to the players position.
	# If it hits anything that the player can collide with, it is NOT in the players
	#	line of sight.
	if player != null:
		var space_state := get_world_3d().direct_space_state
		
		var exceptions: Array[RID] = []
		for nodePath in line_of_sight_exceptions:
			# TODO: casting `as PhysicsBody3D` won't be necessary once the array is typed
			exceptions.append((get_node(nodePath) as PhysicsBody3D).get_rid())
		
		var params := PhysicsRayQueryParameters3D.create(
			global_position, 
			player.global_position, 
			player.collision_mask, 
			exceptions
		)
		
		var result := space_state.intersect_ray(params)
		if result == {}:
			return true
			
	return false
	

## Returns true if the object is currently interactable.
## All nodes that have interactables on them must have this function implemented.
## Some objects might not be interactable at certain times.
## For example, the door is not interactable while the open or close animation is playing.
func is_interactable() -> bool:
	if disabled: return false
	
	if get_parent().has_method("is_interactable"):
		return get_parent().is_interactable()
	else:
		printerr("please implement an 'is_interactable' method for: " + str(get_parent().name))
		return false


## Triggers the interaction.
## This is called from the interaction manager.
func trigger_interaction() -> void:
	if get_parent().has_method(interact_function):
		if active:
			get_parent().call(interact_function)
		
	else:
		printerr("Please implement the method '" + interact_function + "' for: " + str(get_parent().name))

## The highlighter indicates whether or not an interaction is active.
## In this demo, the highlighter is a 3d Sprite, but it could be anything.
## For exmaple, if an interactable is active, its parent could glow, or have a white outline.
func set_highlighter_visibility(value: bool) -> void:
	highlighter.visible = value
