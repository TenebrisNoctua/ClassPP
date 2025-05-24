# Function Overloading

Just like in many languages such as C++, Class++ supports function overloading. <br>
Function Overloading is a feature where multiple functions can share the same name, but they are different from each other with different amount of arguments.

To do function overloading in Class++, you have to use the `class.overload(<accessSpecifier>, <name>, <functionTable>)` function.

```lua
local class = ClassPP.class

local Test = class "Test" {
    Public = {
        ValueA = 0,
        ValueB = 0
    }
}

Test.overload("Public", "Set", {
	function(self, a, b)
		print(a, b)
        self.ValueA = a
        self.ValueB = b
	end,
	function(self, a)
		print(a)
        self.ValueA = a
	end,
    function(self)
        print(self.ValueA, self.ValueB)
    end
})

local newTest = Test.new()
newTest:Set(1, 2) -- Prints "1 2"
newTest:Set(3) -- Prints "3"
newTest:Set() -- Prints "3 2"
```

In this example, to create an overloaded function, we used the `.overload()` function with the `Public` access specifier, and `Set` for the function name. Then we gave a table with multiple functions with different arguments that each do a different thing. When we call the `:Set()` function through the object, depending on the amount of the given arguments, only the function that accepts the same amount of arguments will be ran.

!!! warning
    Giving multiple functions that have the same amount of arguments will cause only one of these functions to be ran. Only create one function for a specific amount of arguments.