extends Interactable

@onready var animation_player = $AnimationPlayer as AnimationPlayer
var is_open = false

func interacted() -> void:
	if animation_player.is_playing():return
	if is_open:
		close_door()
	else:
		open_door()
	
func open_door():
	animation_player.play("Open")
	
	
func close_door():
	animation_player.play("Close")
	
	
func door_opened():
	is_open = true
	interaction_label.text = "(E) Close"


func door_closed():
	is_open = false
	interaction_label.text = "(E) Open"
