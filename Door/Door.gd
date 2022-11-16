extends Interactable

@onready var animation_player = $AnimationPlayer as AnimationPlayer
@onready var highlighter = $Highlight
var is_open = false

func interacted() -> void:	
	if is_open:
		close_door()
	else:
		open_door()
	
	InteractableManager.update_prompt()

func is_interactable() -> bool:
	return !animation_player.is_playing()


func get_prompt_text() -> String:
	if is_open:
		return "Close Door"
	else:
		return "Open Door"
		
		
func highlight(value:bool) -> void:
	highlighter.visible = value

	
func open_door():
	animation_player.play("Open")
	
	
func close_door():
	animation_player.play("Close")
	
	
func door_opened():
	is_open = true
	InteractableManager.update_prompt()


func door_closed():
	is_open = false
	InteractableManager.update_prompt()
