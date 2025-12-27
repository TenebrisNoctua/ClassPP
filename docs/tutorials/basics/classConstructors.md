# Class Constructors and Destructors

Up until this point, we have only updated an object's members from either on the main thread, or inside of a class method. This is fine when it comes to public members, as they can be accessed anywhere. However, when it comes to other member types, such as private members, this can become *tedious*, as you have to call a class method every single time if you want to update them after object creation.

Fortunately, to solve these issues, there are 2 special functions that you can define in every class, called: `constructor` and `destructor`.

## Class Constructors

A constructor is a special function that gets called when an object is created. To create a constructor, you have to specifically define a function called `constructor` outside of the access specifiers. Constructors can be really useful for setting initial values for certain members.

```luau
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

When `Car.new()` is called, it will automatically call the constructor function.

### Constructor Parameters

Constructors, like regular class methods, can take parameters. Unlike class methods however, a constructor will always have `self` (the object) as the first parameter, regardless of how you call the `class.new()` function.

```luau
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

A destructor is a special function that runs when you call the default `:Destroy()` method on an object. To create a destructor, you have to specifically define a function called `destructor` outside of the access specifiers.

!!! info
    `object:Destroy()` is a reserved special method that all objects have. Due to this, you cannot define any member or a method that is called "Destroy".

```luau
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

Instances, threads and connections inside an object will automatically be destroyed during the clearing process as well.

### Automatic Object Destruction

Unlike any other class and object creation system in Luau, Class++ comes with a built-in automatic object destruction system. This system automatically destroys an object when it deems there are no longer any references made to the object itself. 

If this system detects that there are no longer any references made to an object, it will first call the `destructor` function for the object, if defined. And next, it will apply the standard destruction protocol for the object, clearing any data left inside.

This system reduces potential memory leaks that may happen due to non-destroyed objects that still have data stored in memory. However, if you wish to apply full manual memory management instead, you can set the [`autoObjectDestruction`](../../api-reference/general/autoObjectDestruction.md) property of the main library to `false`.

!!! info
    Constructor and Destructor functions can also be written in the outside class definition syntax.
