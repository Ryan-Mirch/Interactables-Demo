extends Node3D

@onready var _animation_player: AnimationPlayer = $AnimationPlayer

var talked_to := false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_animation_player.animation_finished.connect(_on_animation_finished)


func _on_animation_finished(animation_name):
	InteractableManager.update()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
# Triggers the interaction. Toggles the door open or closed
func interact() -> void:
	_animation_player.play("Talk")
	talked_to = true
	InteractableManager.update()


# Returns `true` if no animation is currently playing
func is_interactable() -> bool:
	return !_animation_player.is_playing()
	
	
func examine() -> void:
	if(!talked_to):
		ExamineManager.examine("A guy. I should try talking to him.")
		
	if(talked_to):
		ExamineManager.examine("A guy. Not really the talkative type.")
