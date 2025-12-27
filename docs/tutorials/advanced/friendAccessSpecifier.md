# Friend Access Specifier

Sometimes, you may wish to access the private members of a class without having to use a class method. Perhaps for a utility or a library function, you may wish to grant them access to the private members of your class. This is where the friend access specifier comes in. 

The friend access specifier allows all functions, and even other classes, defined inside itself to access the private members of a class.

!!! warning
    Members of this access specifier will not be replicated to objects, rather, these members are stored in the class itself.

```luau
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

In this example, we have a "Car" class that contains a private member called `License_Plate`, and a local function called `getLicensePlate`.
By passing the reference to the `getLicensePlate` function inside the friend access specifier, this function is now able to access the private members of a class.

!!! info
    Besides functions, friend access specifier can include other classes as well.
    Classes can be saved by using their variables, or their names. You can put a string inside the friend access specifier that contains a class's name, and it will still work!