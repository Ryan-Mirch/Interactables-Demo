extends Node3D

@onready var open_interactable: Interactable = $"Interaction - Open"
@onready var _animation_player: AnimationPlayer = $"Animations"


var opened := false
## Set to true if the player has the key
var unlocked := false


## Triggers the interaction. Toggles the door open or closed
func interact() -> void:	
	if not unlocked: 
		_animation_player.play("Locked")
		return
		
	opened = true
	open_interactable.disable()
	_animation_player.play("Open")
	
	InteractableManager.update_interactables_in_range()
	
	
func examine() -> void:
	if opened:
		ExamineManager.examine("Treasure!")
		
	else:
		ExamineManager.examine("It's locked. There must be a key somewhere...")


## Returns `true` if no animation is currently playing
func is_interactable() -> bool:
	return true
	

