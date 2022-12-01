extends Interactable

var opened = false
var unlocked = false

@onready var _animation_player = $"Animations"
@onready var _highlighter: Sprite3D = $Highlight

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	_highlighter.visible = false
	
	
# Triggers the interaction. Toggles the door open or closed
func trigger_interaction() -> void:
	if !unlocked: 
		_animation_player.play("Locked")
		return
		
	opened = true
	_animation_player.play("Open")
	InteractableManager.update()


# Returns `true` if no animation is currently playing
func is_interactable() -> bool:
	return !opened
	


# Shows or hides the highlight dot
func highlight(is_highlighted: bool) -> void:
	_highlighter.visible = is_highlighted


# Gets the interaction name. This is used to display a prompt to the user.
# @returns the text to write to prompt the user to interact
func get_prompt_text() -> String:
	if unlocked: return "Open Chest"
	else: return "Requires Key"
