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

local Car = Vehicle.extends "Car" { -- Derived Class
    Public = {
        License_Plate = "A1B2C3"
    }
}

local newCar = Car.new()
newCar:honk()
print(newCar.Brand, newCar.Model, newCar.License_Plate, newCar.Year) -- Prints Tesla S A1B2C3 2012!
```

In this example, we have 2 classes: The Vehicle class (base), and the Car class (child). <br>
We create the Car class by calling the function `.extends()` on the Vehicle class, the `.extends()` function works almost the same as the `class` function, it takes in a name, and the class data. 

When you create a class using `.extends()`, you create a new derived class that inherits all of the members and member functions from the base class, so you don't need to re-declare them again. The members are overwritable in the derived class, like in the example above, you can modify the `License_Plate`'s default value to anything you wish. The same applies to other members.

!!! question
    "Why should I use Inheritence?"
    It's very useful for code reusability: reusing members and functions of an existing class when you're creating a new class will save you a lot of time and effort, defining same members over and over again may cause spaghetti code and decrease code readability.

## Multilevel Inheritance

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

local Child = Person.extends "Child" { -- Derived Class
    Public = {
        Age = 9,
        Energetic = true
    }
}

local Student = Child.extends "Student" { -- Derived Class from a Derived Class
    Public = {
        SchoolId = 0,
        Grade = 0,
        Behaviour = "Good"
    }
}

local newStudent = Student.new()
print(newStudent.Name, newStudent.Age, newStudent.Gender, newStudent.Height, newStudent.Age, newStudent.Energetic, newStudent.SchoolId, newStudent.Grade, newStudent.Behaviour)
-- Prints " 9  0 9 true 0 0 Good" (Spaces represent empty strings)
```

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

local BiggerCar = Car.extends "BiggerCar" {
    Public = {
        Brand = "Tesla"
    }
}

function BiggerCar.Public:printLicensePlate()
    print(self.License_Plate) -- Will print "XXXX"
end

local newCar = BiggerCar.new()
newCar:printLicensePlate()
```

In this example, we put the member `License_Plate` under the `Protected` access specifier, and created a new class inherited from the Car class. The inherited class and it's member functions will now be able to access this member. 