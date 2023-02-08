extends Node3D

# TODO: replace this with Array[Chest] when 
# https://github.com/godotengine/godot/issues/66698 is fixed
@export var unlockables: Array[NodePath]

@onready var _animation_player: AnimationPlayer = $"Pickup Animation"

var picked_up := false

# TODO: when Array[NodePath] is replaced with Array[Chest], this won't be
# necessary anymore
func _ready() -> void:
	if OS.is_debug_build():
		for index in unlockables.size():
			var node_path := unlockables[index]
			assert(node_path != null and not node_path.is_empty(), "node %s is null"%[index])
			assert("unlocked" in get_node(node_path), "Node %s does not have an unlocked property"%[node_path])


## Triggers the interaction. Toggles the door open or closed
func interact() -> void:
	for node_path in unlockables:
		var node := get_node(node_path)
		node.unlocked = true
		
	picked_up = true
	_animation_player.play("Pickup")
	InteractableManager.update_interactables_in_range()
	
	
func examine() -> void:
	ExamineManager.examine("This probably unlocks the chest.")
	
	
## Returns `true` if no animation is currently playing
func is_interactable() -> bool:
	return not picked_up
	

