extends Node3D

@export var unlockables: Array[NodePath]

@onready var _animation_player = $"Pickup Animation" as AnimationPlayer

var picked_up = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
	
# Triggers the interaction. Toggles the door open or closed
func interact() -> void:
	for node_path in unlockables:
		var node = get_node(node_path)
		node.unlocked = true
		
	picked_up = true
	_animation_player.play("Pickup")
	InteractableManager.update()
	
	
func examine() -> void:
	print(name + " examined")
	
	
# Returns `true` if no animation is currently playing
func is_interactable() -> bool:
	return !picked_up
	

