# Classes and Objects

A class is an user defined data structure. It's made out of members and member functions. Those members and member functions can then be accessed by creating an object from that class. Think of a class as a blueprint for an object.

## Creating a Class

Here's an example of a person class:

```lua
local class = ClassPP.class

local person = class "Person" {
    Public = {
        Name = "",
        Age = 0
    }
}
```
To create a new basic class, you use the `class()` function with the above syntax. The first argument will be a string that defines the name of the class, and the next argument is the class data, a table that contains all the access specifiers and the member data.

In the above example, we created a new class with the name `Person`, and we created two members named: `Name` and `Age` under the Public access specifier. <br>
Then, we assigned default values to them. These values will be transferred to the object when it gets created.

## Creating an Object

Now that we have created our class, we can now move on to creating an object from this class.
In Class++, to create an object, you use the `class.new()` function. This function returns an object created from this class, and will contain all of the members that you've defined.

```lua
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

Objects will have the members and their default values that you've set in the class data table, so if you want to update them, you can simply index the object with the member name and set it to something else!

```lua
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
    Unlike the classic class creation method in Luau that programmers use, in Class++, to define a member you must do it through the `class()` function (or by simply indexing the class). Trying to define a new member through the object will cause an error.

    ```lua
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


