# Friend Access Specifier

Friend access specifier allows anyone defined in that access specifier to access the private members of a class.

!!! warning
    This access specifier is not generally meant to store members in, but rather serve as something that allows classes or functions outside of a specific class to access that class's private members.

```lua
local function getLicensePlate(object: any)
    print(object.License_Plate)
end

local class = ClassPP.class

local Car = class "Car" {
    Public = {
        Brand = "Lamborghini",
    },
    Private = {
        License_Plate = "XXXX"
    },
    Friend = {
        getLicensePlate
    }
}

local newCar = Car.new()
getLicensePlate(newCar)
```

In this example, we updated the previous class to include a function in the `Friend` access specifier, this function is now able to access the private members of this class. 

!!! info
    Aside from functions, `Friend` access specifier can include other classes as well.
    Classes can be saved by using their variables, or their names. You can put a string inside the `Friend` access specifier that has the class's name, and it will still work!