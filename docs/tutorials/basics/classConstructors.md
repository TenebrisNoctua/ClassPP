# Class Constructors and Destructors

Up until this point, when we created an object from a class and we wanted to update the object, we had to update it either in a class function or outside of the class. Especially when it comes to updating private members, this can get tedious, as you have to define a class method if you want to update them after creation. <br>

Fortunately, to solve these issues, there are 2 special functions that you can define in every class, called: `constructor` and `destructor`.

## Class Constructors

A constructor is a special function that gets called when an object is created. To create a constructor, you have to specifically define a function called `constructor` outside of the Access Specifiers. Constructors can be really useful for setting initial values for certain members.

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

Constructors, like regular class methods, can take parameters. Unlike class methods however, a constructor will always have `self` as the first parameter, regardless of how you call the `class.new()` function.

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

A destructor is a special function that runs when you call the default `:Destroy()` method on an object. To create a destructor, you have to specifically define a function called `destructor` outside of the Access Specifiers.

!!! info
    `object:Destroy()` is a reserved special method that all objects have. Due to this, you cannot define any member or a method that is called "Destroy".

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

Unlike `constructor`, the `destructor` function does not take any additional parameters, and the only parameter will be the `self` pointing to the object. After the `destructor` is called, all members inside the object will be set to `nil`, and the object will be locked, preventing any further access. At this stage, the object should be treated as completely empty and gone, so you should remove all references to the object to prevent memory leaks.

Instances, threads and connections inside an object will automatically be destroyed and cleared during the clearing process as well.

!!! warning
    While manual memory management is recommended, Class++ will automatically call the `destructor` on any object that no longer has any references. This is to prevent memory leaks that might cause many problems if you have objects that can put a heavy toll on the memory.

!!! info
    Constructor and Destructor functions can also be written in the outside class definition syntax.
