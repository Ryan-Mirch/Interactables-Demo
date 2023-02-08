## An Autoload that takes care of tracking currently used Interactables
## And picks which should be active
extends CanvasLayer

@onready var prompt_label: Label = %PromptLabel 
@onready var prompt_container: PanelContainer = %PromptContainer

var player: Player

## Keeps track of any interactable that can be interacted with
var interactables_in_range: Array[Interactable] = []


func _ready() -> void:
	prompt_container.hide()


func _process(_delta: float) -> void:
	# If there is more than 1 interactable in range, and the player has moved,
	# update the interactables
	if interactables_in_range.size() > 1 and player != null and player.velocity != Vector3.ZERO:
		update_interactables_in_range()


## Reads interactable inputs, and triggers the interactions
## Because all of the inputs are handled here, its easy to prevent 1 input from
#	triggering multiple interactables at the same time.
func _input(event: InputEvent) -> void:
	for interactable in interactables_in_range:
		if not interactable.active:
			continue
		
		if event.is_action_pressed(interactable.interact_action):
			interactable.trigger_interaction()
			
			# This break stops a single input event from triggering multiple interactions.
			break


## Deactivates the interactables that should be deactivated
## Activates the interactable that should be activated
func update_interactables_in_range() -> void:
		
	# first, deactivate all interactables
	# deactivating disables the interactable and hides its highlighter
	for interactable in get_tree().get_nodes_in_group("Interactable"):
		interactable.deactivate()
	
	# obtain all interactables from the closest object that has at least 1 interactable
	var interactables_to_activate := _get_interactables_to_activate()
	
	# if no suitable interactable is in sight, hide the prompt and exit
	if interactables_to_activate.size() == 0: 
		prompt_container.hide()
		return
	
	# otherwise, update the prompt and activate the interactables
	prompt_label.text = ""
	
	for interactable in interactables_to_activate:
		if prompt_label.text != "": prompt_label.text += "    "
		prompt_label.text += interactable.prompt_text 
		interactable.activate()
		
	prompt_container.show()
	
	# show the highlighter of only the first interactable
	# all interactables have a highlighter, but we only need to show one.
	interactables_to_activate[0].set_highlighter_visibility(true)


## Out of all the interactables in range, this finds the interactable that is 
## best interacted with and returns an array of it plus all its sibling interactables. 
## Currently, this finds the closest interactables, but you could change it to
## any logic necessary for your game here; most urgent item, most dangerous, highest priority, etc
## @returns an Array[Interactable], or an empty Array if no valid interactables were found.
func _get_interactables_to_activate() -> Array[Interactable]:
	
	var valid_interactables: Array[Interactable] = []
	var result: Array[Interactable] = []
	
	# Get all interactables that can actually be interacted with, which I call
	# 	"valid interactables".
	for interactable in interactables_in_range:
		if interactable.is_interactable() and interactable.player_is_in_line_of_sight():
			valid_interactables.append(interactable)
	
	# If none are found, return an empty Array.
	if valid_interactables.size() == 0: 
		return result	
	
	# The following finds the closest valid interactable.
	var closest_interactable := valid_interactables[0]
	var smallest_distance := closest_interactable.global_position.distance_to(player.global_position)
	
	for interactable in valid_interactables:
		var check_distance := interactable.global_position.distance_to(player.global_position)
		if check_distance < smallest_distance:
			smallest_distance = check_distance
			closest_interactable = interactable
			
	# Add the closest valid interactable to the results Array.
	result.append(closest_interactable)
	
	# Add every interactable that is a sibling of the closest interactable
	# Sibling meaning a child of its parent.
	for sibling in closest_interactable.get_parent().get_children():
		if sibling is Interactable and sibling != closest_interactable and sibling.is_interactable():
			result.append(sibling)
	
	# This makes the interactables higher up in the tree to appear first in the array,	
	#	causing their prompts to appear first. Otherwise, its just random.
	result.sort_custom(sort_child_order)
		
	return result
	
	
## Sorts based on its index in the tree.
func sort_child_order(a: Node, b: Node) -> bool:
	return a.get_index() < b.get_index()


## Adds an interactable to the "interactables in range" list, 
## 	then updates which interactable should be highlighted.
## This is called from an interactable when the player comes within range.
func add_interactable_in_range(interactable: Interactable) -> void:	
	interactables_in_range.append(interactable)
	update_interactables_in_range()


## Deactivates an interactable, then removes it from the "interactables in range" list.
## This is called from an interactable when the player leaves it's range.
func erase_interactable_in_range(interactable: Interactable) -> void:
	interactable.deactivate()
	interactables_in_range.erase(interactable)
	update_interactables_in_range()
