# Static Members

Static members are members of the class that will exist regardless of whether or not any objects of the class are created.<br>
Once a static member has been created, they cannot be destroyed or modified in any way. Static members are also global, so all class objects have access to them, and their property will be the same across all of the objects.

To create a static member in Class++, you have to use the `class.static(<accessSpecifier>, <name>, <property>)` function.

```luau
local class = ClassPP.class

local Test = class "Test" {
	Public = {
		TestValue = 0
	}
}

Test.static("Public", "StaticTestValue", function(firstArgument)
	print(firstArgument) -- This will not point to any object, instead it will print whatever it is called with! In this case, it will print "Hi!".
end)

local newTest = Test.new()
newTest:StaticTestValue() -- This will error!

Test.StaticTestValue("Hi!") -- This will work fine!
```

You can also give properties that aren't functions. To retrieve those properties, you can do `class.<memberName>.property` or `class.<memberName>.p` for short.

```luau
local class = ClassPP.class

local Test = class "Test" {
	Public = {
		TestValue = 0
	}
}

Test.static("Public", "StaticTestValue", 1)

print(Test.StaticTestValue.property) -- Prints "1"!
print(Test.StaticTestValue.p) -- Also prints "1"!
```



