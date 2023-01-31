extends Node3D

@onready var open_interactable = $"Interaction - Open"

var opened = false

# Set to true if the player has the key
var unlocked = false

@onready var _animation_player = $"Animations"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
	
# Triggers the interaction. Toggles the door open or closed
func interact() -> void:	
	if !unlocked: 
		_animation_player.play("Locked")
		return
		
	opened = true
	open_interactable.disable()
	_animation_player.play("Open")
	
	InteractableManager.update()
	
	
func examine() -> void:
	if(opened):
		ExamineManager.examine("A chest that I opened with the key.")
		
	else:
		ExamineManager.examine("It's locked. There must be a key somewhere...")


# Returns `true` if no animation is currently playing
func is_interactable() -> bool:
	return true
	

