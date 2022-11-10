class_name Interactable extends Area3D

@export var interaction_label_text = "Interact"

const interaction_label_scene = preload("res://Interactable/InteractionLabel.tscn")
var _in_range = false
var interaction_label

func _ready() -> void:
	connect("body_entered",_on_body_entered)
	connect("body_exited",_on_body_exited)
	interaction_label = interaction_label_scene.instantiate()
	add_child(interaction_label)
	interaction_label.text = interaction_label_text
	interaction_label.hide()

func _on_body_entered(body: Node3D) -> void:
	interaction_label.show()
	_in_range = true

func _on_body_exited(body: Node3D) -> void:
	interaction_label.hide()
	_in_range = false

func _input(event: InputEvent) -> void:
	if _in_range:
		if event.is_action_pressed("ui_interact"):
			interacted()
			
func interacted() -> void:
	print("Interacted!")
