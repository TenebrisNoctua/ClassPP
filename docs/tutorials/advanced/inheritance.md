# Inheritance

Just like in other object oriented languages, Class++ allows you to inherit classes. 
We group the inheritance concept into two categories: derived class (child), and the base class (parent).
Inheritance implements an *is-a* relationship between classes.

```luau
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

In this example, we have 2 classes: The "Vehicle" class (base), and the "Car" class (child). <br>
We created the Car class by providing the `class` function a list of classes to inherit from (in this case, only the Vehicle class), and the `classData` table after.

When you create a class using this method, you create a new derived class that inherits all of the members and member functions from the class(es) provided, so you don't need to re-declare them again. The members are overwritable in the derived class, like in the example above, you can modify the `License_Plate`'s default value to anything you wish. The same applies to other members.

!!! question
    "Why should I use Inheritence?"
    It's very useful for code reusability: reusing members and functions of an existing class when you're creating a new class will save you a lot of time and effort, defining same members over and over again may cause spaghetti code and decrease code readability.

----

## Protected Access Specifier

In Class++, private members can never be inherited by derived classes. But what if you wanted to make a member able to be inherited by other classes, while still preventing outside access to it? 

The protected access specifier allows you to achieve exactly this, the members stored in this access specifier can be inherited by derived classes, while still being inaccessible from the outside world.

```luau
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

In this example, we put the member `License_Plate` under the protected access specifier, and created a new class that inherits from the "Car" class. This derived class and its methods will now be able to access this member. 

Members in the protected access specifier are overwritable by members in other access specifiers. This means, when you define a member in the public or the private access specifier that has the same name as a member in the protected access specifier, this new member will overwrite the protected member, meaning the protected member will now be removed.

```luau
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
        License_Plate = "A1B2C3"
    }
}

function BiggerCar.Public:printLicensePlate()
    print(self.License_Plate) -- Will print "A1B2C3"!
end

local newCar = BiggerCar.new()
newCar:printLicensePlate()
```

----

## super

Let's say that you want to access a method in a base class from a derived class, how would you do it?
Creating a new object from the base class and calling the method would be tedious, as it would take longer to write and would reduce performance and increase memory usage.

Fortunately, for this, you can just call the default `super` method of an object, which allows you to call the method in a base class that has the same name of the method it's been called from.

```luau
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

local B = class "B" (A, nil) { 
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

In this example, we created a new class called "B" that inherits from "A". In both classes, we have a method called `getVariable()`. In the base class, this method returns the value of the member `Variable_A`, and in the derived class, this method returns the value from the `getVariable()` method from the base class, by calling the `super()` method. 

!!! warning
    `super` cannot be used within classes that have multi-inheritance. This is due to ambiguity that occurs with functions that have the same name in classes that have multi-inheritance. 

----

## Multilevel-Inheritance

A class can also be derived from one class, which can be derived from another class:

```luau
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

!!! warning
    Multi-Inheritance is not Multilevel-Inheritance. While their names may be similar, they represent different concepts.

A class can also be derived from multiple classes:

```luau
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

### The Diamond Problem

The Diamond Problem is an ambiguity that arises when two classes, let's say "B" and "C", that inherits from a class called "A", and another class "D" that inherits from both "B" and "C". If there is a method in "A" that "B" and "C" have overridden, and "D" does not override it, then which version of the method does "D" inherit from: that of "B", or that of "C"?

```luau
local class = ClassPP.class

local A = class "A" { 
    Public = {
        method = function(self)
            print("Method from A")
        end
    }
}

local B = class "B" (A, nil) { 
    Public = {
        method = function(self)
            print("Method from B")
        end
    }
}

local C = class "C" (A, nil) { -- Derived Class
    Public = {
        method = function(self)
            print("Method from C")
        end
    }
}

local D = class "D" (B, C) { -- Derived Class
    Public = {
        -- Which method will D have, B's or C's?
    }
}
```

### How Class++ solves the Diamond Problem

In Class++, the class inheritation system does not work by referencing the parent classes, but rather for the sake of performance, it *combines* the given classes into a new one. The combination is done in an order, from the first given class argument to the last. Certain Access Specifiers such as Protected can change how this system behaves.

To create class "D", Class++ takes the class arguments one by one in an order, from left to right, and combines their `classData` and the given `classData` table into a new class. So due to this order, class "B"'s members and methods will automatically be overwritten by class "C"'s, therefore the method that will exist on class "D", will be the method of class "C"'s.

This is similar to the Python's [MRO (Method Resolution Order)](https://docs.python.org/3/howto/mro.html).

```luau
local class = ClassPP.class

local A = class "A" { 
    Public = {
        method = function(self)
            print("Method from A")
        end
    }
}

local B = class "B" (A, nil) { 
    Public = {
        method = function(self)
            print("Method from B")
        end
    }
}

local C = class "C" (A, nil) { -- Derived Class
    Public = {
        method = function(self)
            print("Method from C")
        end
    }
}

local D = class "D" (B, C) {} -- Derived Class

local newObject = D.new()
newObject:method() -- Prints "Method from C"!
```



