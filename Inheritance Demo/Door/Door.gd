extends Interactable


@onready var _animation_player: AnimationPlayer = $AnimationPlayer
@onready var _highlighter: Sprite3D = $Highlight

# Tracks the door's state. Changes at the end of an animation
var _is_open = false


func _ready() -> void:
	super._ready()
	_animation_player.animation_finished.connect(_on_animation_player_animation_finished)
	_highlighter.visible = false


# Triggers the interaction. Toggles the door open or closed
func trigger_interaction() -> void:	
	if _is_open:
		_animation_player.play("Close")
	else:
		_animation_player.play("Open")
	InteractableManager.update_interactables_in_range()


# Returns `true` if no animation is currently playing
func is_interactable() -> bool:
	return (not _animation_player.is_playing())


# Shows or hides the highlight dot
func highlight(is_highlighted: bool) -> void:
	_highlighter.visible = is_highlighted


# Gets the interaction name. This is used to display a prompt to the user.
# @returns the text to write to prompt the user to interact
func get_prompt_text() -> String:
	if _is_open:
		return "Close Door"
	else:
		return "Open Door"


func _on_animation_player_animation_finished(animation_name: String) -> void:
	if animation_name == "RESET":
		return
	_is_open = animation_name == "Open"
	InteractableManager.update_interactables_in_range()
