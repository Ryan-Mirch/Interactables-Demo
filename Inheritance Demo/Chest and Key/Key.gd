extends Interactable

@export var unlockables: Array[NodePath]

@onready var _highlighter: Sprite3D = $Highlight
@onready var _animation_player = $"Pickup Animation" as AnimationPlayer

var picked_up = false

## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	_highlighter.visible = false
	
	
## Triggers the interaction. Toggles the door open or closed
func trigger_interaction() -> void:
	for node_path in unlockables:
		var node = get_node(node_path)
		node.unlocked = true
		
	picked_up = true
	_animation_player.play("Pickup")
	InteractableManager.update_interactables_in_range()
	
	


## Returns `true` if no animation is currently playing
func is_interactable() -> bool:
	return !picked_up
	


## Shows or hides the highlight dot
func highlight(is_highlighted: bool) -> void:
	_highlighter.visible = is_highlighted


## Gets the interaction name. This is used to display a prompt to the user.
## @returns the text to write to prompt the user to interact
func get_prompt_text() -> String:
	return "Grab Key"
