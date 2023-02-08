extends Node3D

@onready var area: Area3D = $Area3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var prompt: Label3D = $Prompt

var player:CharacterBody3D


func _ready() -> void:
	area.body_entered.connect(_on_area_3d_body_entered)
	area.body_exited.connect(_on_area_3d_body_exited)


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


func _on_area_3d_body_exited(_body: Node3D) -> void:
	player = null
	prompt.visible = false
