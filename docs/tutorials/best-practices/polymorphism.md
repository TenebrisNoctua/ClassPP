# Polymorphism

In simple terms, Polymorphism stands for "many forms", it's one of the core concepts of OOP.
It refers to situations where something occurs in several different forms, and describes the concept that you can access objects of different types through the same interface.

[Function Overloading](functionOverloading.md), [Operator Overloading](operatorOverloading.md), and [Inheritance](inheritance.md) belong to this concept, for example with inheritance, we can create derived classes that have the same method name, but all do different things. Or with function overloading, every function has different arguments and does a different thing, but all share the same name. It provides flexibility, and extensibility.

----

## Inheritance Example

```lua
local class = ClassPP.class

local Animal = class "Animal" {
    Public = {
        animalSound = function(self)
            print("The animal makes a sound")
        end
    }
}

-- Derived class
local Pig = class "Pig" (Animal, nil) {
    Public = {
        animalSound = function(self)
            print("The pig says: oink oink")
        end
    }
}

-- Derived class
local Dog = class "Dog" (Animal, nil) {
    Public = {
        animalSound = function(self)
            print("The dog says: woof woof")
        end
    }
}
```

----

## Function Overloading Example

```lua
local class = ClassPP.class

local Test = class "Test" {}
Test.overload("Public", "Display", {
    function(self, number1)
        print("Number: ", number1)
    end,
    function(self, number1, number2)
        print("Numbers: ", number1, number2)
    end
})
```