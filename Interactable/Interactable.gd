class_name Interactable extends Area3D


func _ready() -> void:
	connect("body_entered",_on_body_entered)
	connect("body_exited",_on_body_exited)
	add_to_group("Interactable")


func _on_body_entered(body: Node3D) -> void:
	InteractableManager.add_in_range_interactable(self)


func _on_body_exited(body: Node3D) -> void:
	InteractableManager.erase_in_range_interactable(self)
	

func is_in_range() -> bool:
	return has_overlapping_bodies()


#Following functions are implemented in the interactable's script
func is_interactable() -> bool:
	return true


func interacted() -> void:
	print("Interacted!")
	
	
func get_prompt_text() -> String:
	return "Prompt"
	
func highlight(value:bool) -> void:
	print("Highlighting")
