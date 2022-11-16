class_name Interactable extends Area3D


func _ready() -> void:
	connect("body_entered",_on_body_entered)
	connect("body_exited",_on_body_exited)


func _on_body_entered(_body: PhysicsBody3D) -> void:
	InteractableManager.add_interactable_in_range(self)


func _on_body_exited(_body: PhysicsBody3D) -> void:
	InteractableManager.erase_interactable_in_range(self)


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
	printerr("This is an abstract method destined to be overridden in subclasses")


# Gets the interaction name. This is used to display a prompt to the user.
# @returns the text to write to prompt the user to interact
func get_prompt_text() -> String:
	return "Prompt"


# Highlights the interactable. This cannot be done generically because it is going.
# to depend on the specific interactable.
# Override in sub-classes to change the behavior.
# @param is_highlighted if true, highlights the interactable. Behavior is left 
#                       at the discretion of the subclass implementation.
func highlight(_is_highlighted: bool) -> void:
	printerr("This is an abstract method destined to be overridden in subclasses")
