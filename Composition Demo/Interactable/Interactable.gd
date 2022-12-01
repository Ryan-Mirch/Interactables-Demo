class_name Interactable extends Area3D

#Used for calculating line of sight
@export var hitboxes:Array[NodePath]
@export var prompt_text:String

var player:CharacterBody3D = null

@onready var highlighter = $Highlighter

func _ready() -> void:
	connect("body_entered",_on_body_entered)
	connect("body_exited",_on_body_exited)
	highlighter.visible = false
	


func _on_body_entered(body: CharacterBody3D) -> void:
	player = body
	InteractableManager.add_interactable_in_range(self)
	

func _on_body_exited(_body: CharacterBody3D) -> void:
	player = null
	InteractableManager.erase_interactable_in_range(self)	
	

func player_is_in_line_of_sight() -> bool:
	if player != null:
		var space_state := get_world_3d().direct_space_state
		
		var exclude = []
		for nodePath in hitboxes:
			exclude.append(get_node(nodePath))
		
		var params = PhysicsRayQueryParameters3D.create(
		global_position, 
		player.global_position, 
		player.collision_mask, 
		exclude)
		
		var result := space_state.intersect_ray(params)
		if result == {}:
			return true
			
	return false

# Below are functions meant to be overridden in subclasses


# Returns true if the object is currently interactable.
# Returns `true` by default, override in sub-classes to change the behavior.
# @returns `true` if the interactable is ready to be interacted with, `false` 
#           otherwise. Specifics are left to the discretion of subclasses
func is_interactable() -> bool:
	return true


# Triggers the interaction. Override this in sub-classes to change the behavior.
# What this does depends on each specific subclass implementation
func trigger_interaction() -> void:
	get_parent()._interacted()


func highlight(_is_highlighted: bool) -> void:
	highlighter.visible = _is_highlighted
