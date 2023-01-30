# An Autoload that takes care of tracking currently used Interactables
# And picks which should receive the interaction
extends CanvasLayer

@onready var prompt_label: Label = %PromptLabel 
@onready var prompt_container: PanelContainer = %PromptContainer

# Keeps track of any interactable that can be interacted with
var player
var interactables_in_range: Array[Interactable] = []


func _ready() -> void:
	prompt_container.hide()
	
	
func _process(_delta: float) -> void:
	
	# If there is more than 1 interactable in range, and the player has moved,
	# update the primary interactable.
	if interactables_in_range.size() > 1 and player.velocity != Vector3.ZERO:
		update()

func _input(event: InputEvent) -> void:
	for interactable in interactables_in_range:
		if !interactable.active: continue
		
		if event.is_action_pressed(interactable.interact_action):
			interactable.trigger_interaction()
			
			# This break is extremely important.
			# After a single interaction input is triggered, no other inputs are read.
			# This stops a single input event from triggering multiple interactions.
			break



# Cycles all current Interactables, finds the primary one, and highlights it.
# Unhighlights all the others
func update() -> void:
	
	# first, deactivate all interactables
	# deactivating disables the interactable and hides its highlighter
	for interactable in get_tree().get_nodes_in_group("Interactable"):
		interactable.deactivate()
	
	# obtain all interactables from the closest object that has at least 1 interactable
	var primary_interactables := _get_primary_interactables()
	
	# if no suitable interactable is in sight, hide the prompt and exit
	if primary_interactables.size() == 0: 
		prompt_container.hide()
		return
	
	# otherwise, update the prompt and activate the interactables
	prompt_label.text = ""
	
	for interactable in primary_interactables:
		if prompt_label.text != "": prompt_label.text += "    "
		prompt_label.text += interactable.prompt_text 
		interactable.activate()
		
	prompt_container.show()
	
	# show the highlighter of only the first interactable
	# all interactables have a highlighter, but we only need to show one.
	primary_interactables[0].set_highlighter_visibility(true)
	
	


# Out of all the interactables in range, returns the interactable that is best
# interacted with. Currently, this is the closest interactable, but you could insert
# any logic necessary for your game here; most urgent item, most dangerous, etc
# @returns an Interactable, or null if no valid interactable was found
func _get_primary_interactables() -> Array[Node]:
	
	var valid_interactables = []
	var result = []
	
	for interactable in interactables_in_range:
		if interactable.is_interactable() and interactable.player_is_in_line_of_sight():
			valid_interactables.append(interactable)
	
	if valid_interactables.size() == 0: 
		return result	
	
	var closest_interactable = valid_interactables[0] as Interactable
	var smallest_distance = closest_interactable.global_position.distance_to(player.global_position)
	
	for interactable in valid_interactables:
		var check_distance = interactable.global_position.distance_to(player.global_position)
		if check_distance < smallest_distance:
			smallest_distance = check_distance
			closest_interactable = interactable
			
	result.append(closest_interactable)
	
	for sibling in closest_interactable.get_parent().get_children():
		if sibling is Interactable and sibling != closest_interactable:
			result.append(sibling)
	
	# This makes the interactables higher up in the tree to appear first in the array,	
	#	causing their prompts to appear first.
	# Otherwise, its just random
	result.sort_custom(sort_child_order)
		
	return result

func sort_child_order(a, b) -> bool:
	return a.get_index() < b.get_index()
	

# Adds an interactable to the list, then updates which interactable should be
# highlighted
func add_interactable_in_range(interactable: Interactable) -> void:	
	interactables_in_range.append(interactable)
	update()

# Removes an interactable from the list, then updates which interactable should
# be highlighted
func erase_interactable_in_range(interactable: Interactable) -> void:
	interactable.deactivate()
	interactables_in_range.erase(interactable)
	update()
	


