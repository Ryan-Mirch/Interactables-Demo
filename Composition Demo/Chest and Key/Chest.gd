extends Node3D

var opened = false
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
	_animation_player.play("Open")
	InteractableManager.update()


# Returns `true` if no animation is currently playing
func is_interactable() -> bool:
	return !opened
	

