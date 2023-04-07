# Interactables: Composition Demo

Demonstrates a flexible way to create multiple interactions with objects.

## Summary

This architecture is similar to the Inheritance Demo, so you should read the description first.

There is one chief difference:

The `Interactable` is supposed to be nested under a parent object. When the `Interactable` is interacted with, it calls an `interact()` method on the parent object.

This composition system fits well with how Godot handles some use cases (such as KinematicBodies requiring Shapes). The Interactable is only responsible for:

- Knowing when the player character is in range
- Knowing when the player character is in line of sight
- Registering itself with the `InteractionManager`.
- Providing the name of the interaction ("open", "push", etc.)
- Receiving the interaction request and relaying it to the parent object

## Pros/Cons

This system makes it easy to throw an `Interactable` as a child of any object and have that object offer interaction. 

For this demo, we made the `Interactable` run a method on the parent, but nothing prevents making the interactables completely independent and handle themselves.

It also makes it possible to have multiple interactables for a single object. A shop owner can then offer the interactions "trade", "talk", "steal", and "attack", for example.

On the other hand, this adds a lot of indirection, making the game significantly harder to understand and debug overall. Only use after confirming this implementation is really what you need!


### When To Use:

- When a single object might propose several interactions
- When game designers may add interactions to arbitrary objects (for example, some doors open and other not; some doors can be lockpicked, etc)
- When a single object may be interacted with, but is also something else (an enemy, loot, etc.)


### When Not To Use:

- Just because "you might need the flexibility later": this system is a lot of tech debt to haul for an entire project's lifetime "just in case".
- When all your interactables can ideally descend from a same class. Inheritance would be easier in this case.