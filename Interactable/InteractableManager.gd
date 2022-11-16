extends Control


@onready var promptLabel = %PromptLabel
@onready var promptContainer = %PromptContainer

var in_range_interactables = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	promptContainer.hide()


func _input(event: InputEvent) -> void:	
	if event.is_action_pressed("ui_interact"):
		var current_interactable = get_current_interactable()
		if current_interactable != null:
			current_interactable.interacted()
			
	
func update_highlighted_interactable() -> void:
	for i in get_tree().get_nodes_in_group("Interactable"):
		i.highlight(false)
		
	var current_interactable = get_current_interactable()
	
	if current_interactable == null: 
		promptContainer.hide()

	else:
		promptLabel.text = current_interactable.get_prompt_text()
		promptContainer.show()
		current_interactable.highlight(true)
	
	
func get_current_interactable():
	for interactable in in_range_interactables:
		if interactable.is_interactable():
			return interactable
			
	return null
	
	
func add_in_range_interactable(i:Interactable) -> void:
	in_range_interactables.insert(0,i)
	update_highlighted_interactable()
	

func erase_in_range_interactable(i:Interactable) -> void:
	in_range_interactables.erase(i)
	update_highlighted_interactable()
	

