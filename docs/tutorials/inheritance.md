# Inheritance

Just like in C++ and many other languages, Class++ allows you to inherit classes. 
We group the inheritance concept into two categories: derived class (child), and the base class (parent).

```lua
local class = ClassPP.class

local Vehicle = class "Vehicle" { -- Base Class
    Public = {
        Brand = "Tesla",
        Model = "S",
        License_Plate = "BITE 1987",
        Year = 2012,
        honk = function(self)
            print("honk honk!")
        end
    }
}

local Car = class "Car" (Vehicle, nil) { -- Derived Class
    Public = {
        License_Plate = "A1B2C3"
    }
}

local newCar = Car.new()
newCar:honk()
print(newCar.Brand, newCar.Model, newCar.License_Plate, newCar.Year) -- Prints "Tesla S A1B2C3 2012"!
```

In this example, we have 2 classes: The Vehicle class (base), and the Car class (child). <br>
We created the Car class by providing the `class` function a list of classes to inherit from (in this case, only the Vehicle class), and the `classData` table after.

When you create a class using this method, you create a new derived class that inherits all of the members and member functions from the class(es) provided, so you don't need to re-declare them again. The members are overwritable in the derived class, like in the example above, you can modify the `License_Plate`'s default value to anything you wish. The same applies to other members.

!!! question
    "Why should I use Inheritence?"
    It's very useful for code reusability: reusing members and functions of an existing class when you're creating a new class will save you a lot of time and effort, defining same members over and over again may cause spaghetti code and decrease code readability.

----

## Multilevel-Inheritance

A class can also be derived from one class, which can be derived from another class:

```lua
local class = ClassPP.class

local Person = class "Person" { -- Base Class
    Public = {
        Name = "",
        Age = 0,
        Gender = "",
        Height = 0
    }
}

local Child = class "Child" (Person, nil) { -- Derived Class
    Public = {
        Age = 9,
        Energetic = true
    }
}

local Student = class "Student" (Child, nil) { -- Derived Class from a Derived Class
    Public = {
        SchoolId = 0,
        Grade = 0,
        Behaviour = "Good"
    }
}

local newStudent = Student.new()
print(newStudent.Name, newStudent.Age, newStudent.Gender, newStudent.Height, newStudent.Age, newStudent.Energetic, newStudent.SchoolId, newStudent.Grade, newStudent.Behaviour)
-- Prints " 9  0 9 true 0 0 Good"! (Spaces represent empty strings)
```

----

## Multi-Inheritance

A class can also be derived from multiple classes:

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

----

## Protected Access Specifier

In the [Access Specifiers](accessSpecifiers.md) section, you have learned that there are 4 access specifiers in Class++, so far you have seen `Public`, `Private` and `Friend`.
The fourth specifier, `Protected`, is pretty much the same as the `Private`, however, aside from the class members, inherited classes will also be able to access these members. 

```lua
local class = ClassPP.class

local Car = class "Car" {
    Public = {
        Brand = "Lamborghini",
    },
    Protected = {
        License_Plate = "XXXX"
    }
}

local BiggerCar = class "BiggerCar" (Car, nil) {
    Public = {
        Brand = "Tesla"
    }
}

function BiggerCar.Public:printLicensePlate()
    print(self.License_Plate) -- Will print "XXXX"!
end

local newCar = BiggerCar.new()
newCar:printLicensePlate()
```

In this example, we put the member `License_Plate` under the `Protected` access specifier, and created a new class inherited from the Car class. The inherited class and it's member functions will now be able to access this member. 

----

## super

Let's say that you want to access a function in the base class from a child class, how would you do it?
Creating a new object from the base class would be tedious, as it would take longer to write and would decrease performance.
Luckily, in Class++ 2.0, you can call the `super` method of the object, which allows you to call the function in the base class that has the same name of the function it's been called from.

```lua
local class = ClassPP.class

local A = class "A" { 
    Public = {
        getVariable = function(self)
            return self.Variable_A
        end
    },
    Protected = {
        Variable_A = 1
    }
}

local B = class "B" (A) { 
    Public = {
        Variable_B = 1,
        getVariable = function(self)
            return self:super()
        end
    }
}

local newObject = B.new()
print(newObject:getVariable()) -- 1
```

In this example, we created a new class called "B" that inherits from "A". In both classes, we have a function called "getVariable", in the base class, this function returns the "Variable_A" member's value, and in the child class, this function returns the value from the "getVariable" function from the parent class, by calling the `super()` method. 

!!! warning
    `super` cannot be used within classes that have multi-inheritance. This is due to ambiguity that occurs with multiple functions that have the same name in classes that have multi-inheritance. 