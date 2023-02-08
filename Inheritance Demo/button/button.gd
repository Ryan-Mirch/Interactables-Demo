extends Interactable

@onready var _highlighter: Sprite3D = $Highlight
@onready var _animation_player: AnimationPlayer = $AnimationPlayer

var picked_up := false

## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	_highlighter.visible = false
	_animation_player.animation_finished.connect(
		# we're forced to have an intermediary function because `animation_finished`
		# uses an argument
		func(_anim_name: String): 
			InteractableManager.update_interactables_in_range()
	)
	
	
## Triggers the interaction. Toggles the door open or closed
func trigger_interaction() -> void:
	_animation_player.play("Press")
	InteractableManager.update_interactables_in_range()
	
	
## Returns `true` if no animation is currently playing
func is_interactable() -> bool:
	return not _animation_player.is_playing()
	


## Shows or hides the highlight dot
func highlight(is_highlighted: bool) -> void:
	_highlighter.visible = is_highlighted


## Gets the interaction name. This is used to display a prompt to the user.
## @returns the text to write to prompt the user to interact
func get_prompt_text() -> String:
	return "Press"


