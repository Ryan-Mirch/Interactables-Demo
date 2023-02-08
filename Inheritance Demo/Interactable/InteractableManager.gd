## An Autoload that takes care of tracking currently used Interactables
## And picks which interactable should receive the interaction
extends CanvasLayer

@onready var prompt_label: Label = %PromptLabel 
@onready var prompt_container: PanelContainer = %PromptContainer

## Keeps track of any interactable that can be interacted with
var interactables_in_range: Array[Interactable] = []
var player: Player


func _ready() -> void:
	prompt_container.hide()


## If there is more than 1 interactable in range, and the player has moved,
## update the primary interactable.
func _process(_delta: float) -> void:
	if interactables_in_range.size() > 1 and player != null and player.velocity != Vector3.ZERO:
		update_interactables_in_range()


func _input(event: InputEvent) -> void:			
	if event.is_action_pressed("ui_interact"):
		var interactable := _get_primary_interactable()
		if interactable != null:
			interactable.trigger_interaction()


## Cycles all current Interactables, finds the primary one, and highlights it.
## Unhighlights all the others
func update_interactables_in_range() -> void:
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


## Out of all the interactables in range, returns the interactable that is best
## interacted with. Currently, this is the closest interactable, but you could change
## this to any logic necessary for your game here; most urgent item, most dangerous, 
## or the closest to the players' line of sight, for example.
## @returns an Interactable, or null if no valid interactable was found
func _get_primary_interactable() -> Interactable:
		
	var valid_interactables = []
	
	for interactable in interactables_in_range:
		if interactable.is_interactable() and interactable.player_is_in_line_of_sight():
			valid_interactables.append(interactable)
	
	if valid_interactables.size() == 0: 
		return null
	
	
	var closest_interactable = valid_interactables[0]
	var smallest_distance = closest_interactable.global_position.distance_to(player.global_position)
	
	for interactable in valid_interactables:
		var check_distance = interactable.global_position.distance_to(player.global_position)
		if check_distance < smallest_distance:
			smallest_distance = check_distance
			closest_interactable = interactable
		
	return closest_interactable


## Adds an interactable to the list, then updates which interactable should be
## highlighted
func add_interactable_in_range(interactable: Interactable) -> void:	
	interactables_in_range.insert(0, interactable)
	update_interactables_in_range()


## Removes an interactable from the list, then updates which interactable should
## be highlighted
func erase_interactable_in_range(interactable: Interactable) -> void:
	interactable.highlight(false)
	interactables_in_range.erase(interactable)
	update_interactables_in_range()


