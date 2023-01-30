extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
# Triggers the interaction. Toggles the door open or closed
func interact() -> void:
	print("Interact")
	InteractableManager.update()


# Returns `true` if no animation is currently playing
func is_interactable() -> bool:
	return true
	
	
func examine() -> void:
	print(name + " examined")
