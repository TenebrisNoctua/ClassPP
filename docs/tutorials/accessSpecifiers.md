# Access Specifiers

Unlike any other class module or system on Roblox, Class++ comes with an Access Specifier system, like in C++, it provides you a way to modify the access control of a member. There are currently 4 access specifiers in Class++: `Public`, `Private`, `Protected`, and `Friend`.<br>
(You will learn about `Protected` and `Friend` later.)

## Public Access Specifier

Like you have seen in the examples on the previous pages, a Public access specifier allows anyone to access a member. Whether it be from a function inside the class or from the script's main thread, the member is accessible and can be modified.

```lua
local class = ClassPP.class

local Car = class "Car" {
    Public = {
        Brand = "Lamborghini",
    }
}

local newCar = Car.new()
newCar.Brand = "Tesla"
```

In this example, we created a new class with a Public member `Brand` that has the default value of `Lamborghini`.<br>
Then we created a new object from this class and modified the `Brand` member of this object. Now the value is set to `Tesla`.

## Private Access Specifier

Private access specifier allows you to hide a member from anyone outside from that class. No one besides the class members can access this member or modify it.

```lua
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

In this example, we updated the previous class with a private member named `License_Plate`, this member is private and can only be accessed by the class members, so trying to access or modify it outside of the class will cause an error.

!!! warning
    A member (property/attribute) can be declared only once. This means a member can only be defined under one access specifier. Attempting to declare another member with the same name on a different access specifier will error.