# classData

```lua
export type classData = {
	constructor: (any: any, ...any) -> ()?,
	destructor: (any: any) -> ()?,
	Public: {[any]: any}?,
	Private: {[any]: any}?,
	Protected: {[any]: any}?,
	Friend: {any}?
}
```

The `classData` table that is given to the [`class()`](../classFunctions/mainModule/class.md) function that contains data about the desired [`class`](../dataTypes/class.md).

----

## Properties

### constructor
<a style="color: lightskyblue;">(any: any, ...any) -> ()?</a>

The `constructor` function that will be called when an `object` gets created.

### destructor
<a style="color: lightskyblue;">(any: any) -> ()?</a>

The `destructor` function that will be called when an `object` gets destroyed.

### Public
<a style="color: lightskyblue;">{[any]: any}</a>

The access specifier that contains properties that can be globally accessable.

### Private
<a style="color: lightskyblue;">{[any]: any}?</a>

The access specifier that contains properties that can only be accessed inside the `class`.

### Protected
<a style="color: lightskyblue;">{[any]: any}?</a>

The access specifier that contains properties that can only be accessed inside the `class` and inherited classes.

### Friend
<a style="color: lightskyblue;">{any}?</a>

The access specifier that contains functions and classes that can access the `class`'s `Private` properties.

