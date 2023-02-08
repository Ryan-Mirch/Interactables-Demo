extends CanvasLayer

@onready var label: Label = $Label
@onready var animationPlayer: AnimationPlayer = $AnimationPlayer


func examine(text: String) -> void:
	label.text = text
	animationPlayer.stop()
	animationPlayer.play("Examine")
