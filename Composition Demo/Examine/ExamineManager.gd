extends CanvasLayer

@onready var label = $Label as Label
@onready var animationPlayer = $AnimationPlayer as AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

func examine(text):
	label.text = text
	animationPlayer.stop()
	animationPlayer.play("Examine")
