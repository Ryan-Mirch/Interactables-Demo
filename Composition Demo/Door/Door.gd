extends Node3D

@onready var _animation_player: AnimationPlayer = $AnimationPlayer
@onready var _interaction_open_close: Interactable = $"Interaction - OpenClose"

## Tracks the door's state. Changes at the end of an animation
var _is_open := false


func _ready() -> void:
	_animation_player.animation_finished.connect(_on_animation_player_animation_finished)


func open_close() -> void:	
	if _is_open:
		_animation_player.play("Close")
		_interaction_open_close.prompt_text = "(E) Open"
	else:
		_animation_player.play("Open")
		_interaction_open_close.prompt_text = "(E) Close"
	InteractableManager.update_interactables_in_range()
	

func examine() -> void:
	if (_is_open):
		ExamineManager.examine("A Sci-Fi sliding door that is currently open.")
		
	else:
		ExamineManager.examine("A Sci-Fi sliding door that is currently closed.")


func is_interactable() -> bool:
	return !_animation_player.is_playing()


func _on_animation_player_animation_finished(animation_name: String) -> void:
	if animation_name == "RESET":
		return
	_is_open = animation_name == "Open"
	InteractableManager.update_interactables_in_range()


