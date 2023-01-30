extends Node3D

@onready var _animation_player: AnimationPlayer = $AnimationPlayer
@onready var _interaction_open_close: Interactable = $"Interaction - OpenClose"

# Tracks the door's state. Changes at the end of an animation
var _is_open = false


func _ready() -> void:
	_animation_player.connect("animation_finished", _on_animation_player_animation_finished)


# Triggers the interaction. Toggles the door open or closed
func interact() -> void:	
	if _is_open:
		_animation_player.play("Close")
		_interaction_open_close.prompt_text = "(E) Open"
	else:
		_animation_player.play("Open")
		_interaction_open_close.prompt_text = "(E) Close"
	InteractableManager.update()
	

func examine() -> void:
	print(name + " examined")


# Returns `true` if no animation is currently playing
func is_interactable() -> bool:
	return !_animation_player.is_playing()



func _on_animation_player_animation_finished(animation_name: String) -> void:
	if animation_name == "RESET":
		return
	_is_open = animation_name == "Open"
	InteractableManager.update()


