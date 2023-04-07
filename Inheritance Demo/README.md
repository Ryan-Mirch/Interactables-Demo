# Interactables: Inheritance Demo

Demonstrates a flexible way to interact with objects.

## Summary

Each object that can be interacted with extends an `Interactable` class.

When the player character enters an `Interactable`'s range, the `Interactable` registers itself with the `InteractionManager` autoload.

The `InteractionManager` is responsible for displaying prompts, and deciding which object receives an interaction event. This allows it to choose on priorities, for example, or check the world for conditions ("Does the player have the key?").

An `Interactable` has a few methods of interest that are overridden in subclasses:

- `trigger_interaction()`, which will run whatever interaction is relevant
- `get_prompt_text()`, which provides the manager with a text ("open", "press", "grab", etc.)
- `highlight()`, which should draw a line around the object, or a circle around the object, or otherwise display some information that the object can be interacted with

Additionally, the `Interactable` has a helper method:

- `player_is_in_line_of_sight()`, which can optionally be used to determine whether the player can reach the interactable. For convenience, the `Interactable` class keeps a reference to the player to check that line of sight.


The `InteractableManager` registers and unregisters `Interactable`s. One method of note is:

- `_get_primary_interactable()`, which decides which interactable receives the "interaction" event if the player presses the key.

## Pros/Cons

OOP programmers will find that model relatively simple to wrap their heads around mentally, and it has a decent amount of flexibility.

Unfortunately, it suffers from needing all interactable objects inherited from the same class.

### When To Use:

- When you need to interact with different objects in the same area, and some may be more important than others
- When you want to create interactions with multiple objects at the same time, such as picking up all objects around the player character
- When you need information about the world to decide if items are interactable

### When Not To Use:

- While prototyping: This implementation adds a lot of indirection and will be much slower to iterate over.
- If you cannot derive all your interactables from a base `Area` class
- If you have a multiple inheritance need (for example, a character that's a shop owner but can also become an enemy if attacked)
- If you have multiple possible interactions with a single object ("eat" or "pickup")