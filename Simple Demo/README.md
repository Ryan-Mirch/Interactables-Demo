# Interactables: Simple Demo

Demonstrates the simplest way to interact with an interactable object.

## Summary

The object has an `Area`; when the player character enters the area, a reference to the player is kept; and when the player character exits the area, the reference is emptied.

Upon pressing "interact", if the player is in the area, the object does something (in this example, the button is pressed).

## Pros/Cons

This is a very straightforward and readable way to build an interaction. It's very little code and will be easy to change later.

### When To Use:

- When prototyping: if you are not sure how your game will work, simpler is better
- When you need many different types of interactions: if each object needs its logic, then copy-pasting this simple code and adding conditions to it is far easier than building a generic solution

### When Not To Use:

- When you have a large number of interactables that function mainly similarly (make sure you have prototyped first and know this for a fact)
- When you need the interactables to know many things about the world, such as "Does the player have the key", or "is there another interactable around that should capture the interaction", or "is the alarm signal on".