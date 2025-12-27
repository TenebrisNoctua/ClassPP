<h1 class="api-header" markdown>
    <span class="api-icon" markdown>:octicons-note-24:</span>
    <span class="api-title">classData</span>
</h1>

```luau
export type classData = {
	constructor: (any, ...any) -> ()?,
	destructor: (any) -> ()?,
	Public: {[string]: any}?,
	Private: {[string]: any}?,
	Protected: {[string]: any}?,
	Friend: {any}?
}
```

The `classData` table that is given to the [`class()`](../class-functions/main/class.md) function that contains data about the desired [`class`](../data-types/class.md).

----

## Properties

<h3 markdown>
	constructor
	<span class="api-property-type">
		: (self: any, ...any) -> ()?
	</span>
</h3>

The `constructor` function that will be called when an `object` gets created.

----

<h3 markdown>
	destructor
	<span class="api-property-type">
		: (self: any) -> ()?
	</span>
</h3>

The `destructor` function that will be called when an `object` gets destroyed.

----

<h3 markdown>
	Public
	<span class="api-property-type">
		: {[string]: any}?
	</span>
</h3>

The access specifier that contains properties that can be globally accessable.

----

<h3 markdown>
	Private
	<span class="api-property-type">
		: {[string]: any}?
	</span>
</h3>

The access specifier that contains properties that can only be accessed inside the `class`.

----

<h3 markdown>
	Protected
	<span class="api-property-type">
		: {[string]: any}?
	</span>
</h3>

The access specifier that contains properties that can only be accessed inside the `class` and inherited classes.

----

<h3 markdown>
	Friend
	<span class="api-property-type">
		: {any}?
	</span>
</h3>

The access specifier that contains functions and classes that can access the `class`'s `Private` properties.

