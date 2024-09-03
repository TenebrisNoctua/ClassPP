# Class Constructors and Destructors

Up until this point, when we created an object from a class, we always updated the object outside of the class, and we had to define a custom function every single time if we wanted to update or access a private member. This is the same for when we want to destroy an object too. This can be tedious after some time, as constantly having to do these steps over and over again for each class will get tiring.<br>
Fortunately, to solve these issues, there are 2 special functions that you can define in every class: `constructor` and `destructor`.

## Class Constructors

A constructor is a special function that gets called when an object is created. To create a constructor, you have to specifically define a function called `constructor` outside of the Access Specifiers.

```lua
local class = ClassPP.class

local Car = class "Car" {
    constructor = function(self)
        self.License_Plate = "YYYY"
    end,
    Public = {
        Brand = "Lamborghini",
    },
    Private = {
        License_Plate = "XXXX"
    }
}

local newCar = Car.new()
```

When `Car.new()` is called, the function will automatically call the constructor function. 

### Constructor Parameters

Constructors, like regular class functions, take parameters. (Just like regular class functions, the first argument will always be self.)<br>
This can be useful for setting inital values for certain members.

```lua
local class = ClassPP.class

local Car = class "Car" {
    constructor = function(self, brand, model, licensePlate)
        self.License_Plate = licensePlate
        self.Brand = brand
        self.Model = model
    end,
    Public = {
        Brand = "",
        Model = "",
        License_Plate = ""
    },
}

local newCar = Car.new("ABCD", "Ford", "Mustang")
print(newCar.Brand, newCar.Model, newCar.License_Plate) -- Prints "ABCD, Ford, Mustang"!
```

## Class Destructors

A destructor is a special function that runs when you call `:Destroy()` on an object. To create a destructor, you have to specifically define a function called `destructor` outside of the Access Specifiers.

```lua
local class = ClassPP.class

local Car = class "Car" {
    constructor = function(self, brand, model, licensePlate)
        self.License_Plate = licensePlate
        self.Brand = brand
        self.Model = model
    end,
    destructor = function(self)
        self.License_Plate = ""
        self.Brand = ""
        self.Model = ""
    end,
    Public = {
        Brand = "",
        Model = "",
        License_Plate = ""
    },
}

local newCar = Car.new("ABCD", "Ford", "Mustang")
print(newCar.Brand, newCar.Model, newCar.License_Plate)

newCar:Destroy() -- The class object will now be destroyed
newCar = nil
```

!!! info
    Unlike `constructor`, the `destructor` function does not take additional parameters, and the only argument will be the self pointing to the object. After the destructor is called, all the members inside the object will be set to nil (Instances inside are automatically destroyed and set to nil too), and the object will be locked, preventing any further access. At this stage, it would be best to set the object variable to nil, so the garbage collector can collect it and prevent memory leaks.

!!! info
    Constructor and Destructor functions can also be written in the outside class definition syntax.
