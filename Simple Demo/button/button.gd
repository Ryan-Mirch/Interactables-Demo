extends Node3D

@onready var area := $Area3D
@onready var animation_player := $AnimationPlayer
@onready var prompt := $Prompt

var player:CharacterBody3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _input(event: InputEvent) -> void:
	#player is NOT in range
	if player == null: return
	
	#player is in range
	if event.is_action_pressed("interact") and !animation_player.is_playing():
		_interacted()
		
	
	
func _interacted():
	animation_player.play("Press")


func _on_area_3d_body_entered(body: Node3D) -> void:
	player = body
	prompt.visible = true
	


func _on_area_3d_body_exited(body: Node3D) -> void:
	player = null
	prompt.visible = false
