extends Node3D

@onready var animation_player := $AnimationPlayer

var player:CharacterBody3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass	
	
	
func _interacted():
	animation_player.play("Press")
