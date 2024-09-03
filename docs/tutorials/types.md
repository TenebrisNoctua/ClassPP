# Types

Currently, Class++ does not support automatic type completion, and requires custom types to be created to use type completion.<br>
In this tutorial, you will learn how to easily create custom types for your classes, and will even learn to use the [`Type`](../apiReference/classFunctions/type/typeof.md) API to typecheck classes and objects!

## Creating a Basic Custom Class Type

```lua
local class = ClassPP.class

type Person = {
	Age: number,
	Name: string,
	Personality: string,
	Job: string,
	Secrets: {string},
	Likes: {string},
	Dislikes: {string},
	getSecrets: (self: Person) -> {string}
}

local Person = class "Person" {
	Public = {
		Age = 0,
		Name = "",
		Personality = "",
		Likes = {},
		Dislikes = {},
		Job = "",
		getSecrets = function(self: Person)
			return self.Secrets
		end,
	},
	Private = {
		Secrets = {}
	}
}

local newPerson: Person = Person.new()
-- This object now supports automatic type completion!
```

In the example above, we created a custom type called "Person" for the Person class, and inserted the types of all the members inside it, and declared the new created member as of the Person type. This allows us to use automatic type completion with our class objects.

!!! info
    Since class objects belong to the base type `userdata`, you can type cast them to either your custom types, or any other existing type you wish.

## Typechecking for Classes and Class Objects

Class++ also comes with its own [`Type`](../apiReference/classFunctions/type/typeof.md) API that allows you to get the types of classes and class objects.

```lua
local class = ClassPP.class
local ctypeof, typeofClass = ClassPP.Type.typeof, ClassPP.Type.typeofClass

type Person = {
	Age: number,
	Name: string,
	Personality: string,
	Job: string,
	Secrets: {string},
	Likes: {string},
	Dislikes: {string},
	getSecrets: (self: Person) -> {string}
}

local Person = class "Person" {
	Public = {
		Age = 0,
		Name = "",
		Personality = "",
		Likes = {},
		Dislikes = {},
		Job = "",
		getSecrets = function(self: Person)
			return self.Secrets
		end,
	},
	Private = {
		Secrets = {}
	}
}

local newPerson: Person = Person.new()
print(ctypeof(Person), ",", ctypeof(newPerson)) -- Prints "Class , Person"!
```

`Type.typeof` will return the true type of the given object. For example, if the object is a `class`, it will return "Class", as it belongs to the [`Class`](../apiReference/dataTypes/class.md) type.<br>
And if the object is a class object, it will return the name of the class it's been created from as its type.

Since `Type.typeof` returns the true type of the given object, to find out the type of a `class`, you have to use the `Type.typeofClass` function. Calling this function with a `class` will return its name as its type.

!!! info
    In Class++, just like in languages such as C++ and Java, a `class`'s type will always be signified by its name.

!!! warning
    Using `class.Name` property may create bugs in certain places as the Type API makes sure the given object is an actual class object before returning its type. It's recommended that you use the Type API instead of the `.Name` property.
