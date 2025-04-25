# Types

## Intellisense

Class++ has been rewritten from ground up, to support the new type-solver and its capabilities. 
This allows Class++ to be more intelligent with the `class` and `object` types, finally allowing the intellisense to be far better than what it used to be. 

```lua
local Person = class "Person" {
	Public = {
		Age = 0,
		Name = "",
		Personality = "",
		Likes = {},
		Dislikes = {},
		Job = "",
		getSecrets = function(self)
			return self.Secrets
		end,
	},
	Private = {
		Secrets = {}
	}
}

local newPerson = Person.new() -- Now has intellisense for members in all access specifiers, and obtains the correct types for every member!
```

This also applies to `class`es, where before you tried to create an inherited `class`, the returned `class` type would not be correct, and new `object`s would not have the correct type. Some members would either be missing or messed up.
Now, this has also been fixed:

```lua
local class = ClassPP.class

local A = class "A" { 
    Public = {
        Variable_A = 1
    }
}

local B = class "B" { 
    Public = {
        Variable_B = 1
    }
}

local C = class "C" (A, B) { -- Derived Class
    Public = {
        Variable_C = 1
    }
}

local newObject = C.new() -- {Variable_A: number, Variable_B: number, Variable_C: number}
```

Though, as much as this update brings in an intellisense much better than before, it is still limited. Like in the previous versions of Class++, to support all of the features of type-completion in Luau, you have to create a custom type and assign it to the created objects.

In the tutorial below, you will learn how to create a basic `Person` type and assign it to the created object, to enable the support.

----

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
-- This object now fully supports all type features of Luau!
```

In the example above, we created a custom type called `Person` for the Person class, and inserted the types of all the members inside it, and declared the new created object as of the Person type. This now allows us to use the all of the features of Luau type-completion.

!!! info
    Since class objects belong to the base type `userdata`, you can type cast them to either your custom types, or any other existing type you wish.

----

## Typechecking for Classes and Class Objects

Class++ also comes with its own [`Type`](../api-reference/classFunctions/type/type.md) API that allows you to get the types of `class`es and `object`s.

```lua
local class = ClassPP.class
local type, typeof = ClassPP.Type.type, ClassPP.Type.typeof

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
print(type(Person), ",", type(newPerson)) -- Prints "Class, Object"!
print(typeof(Person), ",", typeof(newPerson)) -- Prints "Person, Person"!
```

### Type.type

`Type.type` will return the true type of the given object. It behaves the same as the built-in luau `type` function, but with additional support for `class`es and `object`s. For example, if the provided object is a `class`, it will return a string called "Class". This is due to the `class` object belonging to the base [`Class`](../apiReference/dataTypes/class.md) type.

The same applies to `object`s, where if the provided object is an `object`, it will return a string called "Object". This is due to the `object` belonging to the base [`Object`](../apiReference/dataTypes/object.md) type.

### Type.typeof

`Type.typeof` will return the type of the given object. Like `Type.type`, it behaves the same as the built-in Roblox `typeof` function, but with additional support for `class`es and `object`s. For example, if the provided object is a `class`, it will return a string containing the name of the `class`. This is due to `class`es are also being types on their own. They can also be represented as types.

For `object`s, this function will return the type of the `class` they belong to. For example, using this function with an `object` created from a "Person" `class`, will return "Person" as its type.

!!! info
	`Type.type` and `Type.typeof` functions can be used to replace the built-in `type` and `typeof` functions, as they behave the same with other provided objects. For example, using `Type.typeof` and `typeof` with a `string` will both return "string".

!!! warning
    Using the `class.Name` property may create bugs in certain places as the Type API makes sure the given object is an actual `class` object before returning its type. It's recommended that you use the Type API instead of the `.Name` property.
