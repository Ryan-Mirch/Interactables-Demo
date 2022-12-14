extends Interactable

@onready var _highlighter: Sprite3D = $Highlight
@onready var _animation_player = $AnimationPlayer as AnimationPlayer

var picked_up = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	_highlighter.visible = false
	_animation_player.animation_finished.connect(func(anim_name): InteractableManager.update())
	
	
# Triggers the interaction. Toggles the door open or closed
func trigger_interaction() -> void:
	_animation_player.play("Press")
	InteractableManager.update()
	
	
# Returns `true` if no animation is currently playing
func is_interactable() -> bool:
	return !_animation_player.is_playing()
	


# Shows or hides the highlight dot
func highlight(is_highlighted: bool) -> void:
	_highlighter.visible = is_highlighted


# Gets the interaction name. This is used to display a prompt to the user.
# @returns the text to write to prompt the user to interact
func get_prompt_text() -> String:
	return "Press"


