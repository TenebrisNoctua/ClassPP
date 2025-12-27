# Classes and Objects

A class is an user defined data structure. It's made out of members and member functions(methods). Those members and member functions can then be accessed by creating an object from that class. Think of a class as a blueprint for an object.

## Creating a Class

To create a new class with Class++, you use the `class()` function of the main library. The first argument must be a string that defines the name of the class, and the next argument must be the `classData`, a table that contains all the access specifiers and the member data.

```luau
local class = ClassPP.class

local person = class "Person" {
    Public = {
        Name = "",
        Age = 0
    }
}
```

In the above example, we created a new class with the name `Person`, and under the public access specifier, we created two members named: `Name` and `Age` with certain default values assigned to them. These members and their default values will be transferred to every object created from this class.

## Creating an Object

Now that we have a class, we can create an object from it. In Class++, to create an object, you use the `.new()` method a class. When called, this method returns an object created from this class, and like it's been mentioned above, it will contain all of the members and their default values from the class it's been created from.

```luau
local class = ClassPP.class

local person = class "Person" {
    Public = {
        Name = "",
        Age = 0
    }
}

local newPerson = person.new()
print(newPerson.Age) -- Prints "0"!
```

### Updating an Object

Of course, by indexing the object with a specific member, you can update that specific member's associated value. There are some restrictions that can be applied to this however, which you will learn in later pages.

```luau
local class = ClassPP.class

local person = class "Person" {
    Public = {
        Name = "",
        Age = 0
    }
}

local newPerson = person.new()
newPerson.Age = 21

print(newPerson.Age) -- Prints "21"!
```

!!! warning
    In Class++, members and their values must be defined through either the `class()` function, or by simply indexing a created class and assigning a new member to an access specifier through it. Trying to define a new member through the object will cause an error.

    ```luau
    local class = ClassPP.class

    local person = class "Person" {
        Public = {
            Name = "",
            Age = 0
        }
    }

    local newPerson = person.new()
    newPerson.Personality = "Cheerful" -- This will error! This class has no member named "Personality".
    ```


