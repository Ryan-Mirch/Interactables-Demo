# An Autoload that takes care of tracking currently used Interactables
# And picks which should receive the interaction
extends CanvasLayer

@onready var prompt_label: Label = %PromptLabel 
@onready var prompt_container: PanelContainer = %PromptContainer

# Keeps track of any interactable that can be interacted with
var interactables_in_range: Array[Interactable] = []


func _ready() -> void:
	prompt_container.hide()


func _input(event: InputEvent) -> void:	
	if event.is_action_pressed("ui_interact"):
		var interactable := _get_primary_interactable()
		if interactable != null:
			interactable.trigger_interaction()


# Cycles all current Interactables, finds the primary one, and highlights it.
# Unhighlights all the others
func update() -> void:
	# first, remove all highlights
	for interactable in interactables_in_range:
		interactable.highlight(false)
	
	# obtain the most important interactable
	var interactable := _get_primary_interactable()
	
	# if no suitable interactable is in sight, hide the prompt and exit
	if interactable == null: 
		prompt_container.hide()
		return
	
	# otherwise, highlight the current interactable
	prompt_label.text = interactable.get_prompt_text()
	prompt_container.show()
	interactable.highlight(true)


# Out of all the interactables in range, returns the interactable that is best
# interacted with. Currently, this is the first interactable, but you could insert
# any logic necessary for your game here; most urgent item, most dangerous, or the
# closest to the players' line of sight, for example.
# @returns an Interactable, or null if no valid interactable was found
func _get_primary_interactable() -> Interactable:
	for interactable in interactables_in_range:
		if interactable.is_interactable():
			return interactable
		
	return null


# Adds an interactable to the list, then updates which interactable should be
# highlighted
func add_interactable_in_range(interactable: Interactable) -> void:
	interactables_in_range.insert(0, interactable)
	update()


# Removes an interactable from the list, then updates which interactable should
# be highlighted
func erase_interactable_in_range(interactable: Interactable) -> void:
	interactable.highlight(false)
	interactables_in_range.erase(interactable)
	update()


