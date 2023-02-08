extends Node3D

@onready var _animation_player := $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_animation_player.animation_finished.connect(
		# we're forced to have this intermediary function because the `finished` 
		# signal uses an argument
		func(_anim_name: String): 
			InteractableManager.update()
	)
	
	
func interact():
	_animation_player.play("Press")
	InteractableManager.update()
	
	
func is_interactable() -> bool:
	return !_animation_player.is_playing()
	
	
func examine() -> void:
	ExamineManager.examine("A giant, red, extremely pressable button.")

