# Access Specifiers

In the previous page, you may have noticed that we have defined our members inside a specific table, called "Public", inside the `classData` table.
This table represents an "Access Specifier". It allows you to modify the access control of a specific member, essentially allowing you to control where the member can be accessed from. This concept comes from certain object oriented languages such as C++, allowing you to apply many OOP concepts effectively in Luau.

There are currently 4 access specifiers in Class++: `Public`, `Private`, `Protected`, and `Friend`.<br>
(`Protected` and `Friend` are mentioned in later pages.)

## Public Access Specifier

The public access specifier allows the members to be accessed from anywhere. Whether it be from a function inside the class or from the main thread, the member is accessible and can be modified.

```luau
local class = ClassPP.class

local Car = class "Car" {
    Public = {
        Brand = "Lamborghini",
    }
}

local newCar = Car.new()
newCar.Brand = "Tesla"
```

In this example, we created a new class with a public member `Brand` that has the default value of `Lamborghini`.<br>
Then we created a new object from this class and modified the `Brand` member of this object. Now the value is set to `Tesla`.

## Private Access Specifier

The private access specifier allows the member to only be accessed from class functions, essentially locking the member from the outside world.

```luau
local class = ClassPP.class

local Car = class "Car" {
    Public = {
        Brand = "Lamborghini",
    },
    Private = {
        License_Plate = "XXXX"
    }
}

local newCar = Car.new()
newCar.License_Plate = "YYYY" -- This will error!
```

In this example, we updated the previous class with a private member named `License_Plate`, this member is private and can only be accessed from the class functions, so trying to access or modify it outside of the class functions will cause an error.

!!! warning
    A member *(property/attribute)* can be declared only once. This means a member can only be defined under one access specifier. Attempting to declare a member in multiple access specifiers will cause an error.