# Class Functions

Just like in other OO languages, there are two ways to define a function *(method)* inside a class:

* Inside class definition
* Outside class definition

## Inside Class Definition

```lua
local class = ClassPP.class

local Car = class "Car" {
    Public = {
        Brand = "Lamborghini",
        getLicensePlate = function(self)
            print(self.License_Plate)
        end
    },
    Private = {
        License_Plate = "XXXX"
    }
}
```

In this example, we have defined a function inside the Public Access Specifier called `getLicensePlate`, this function when called will print the license plate of our object. 

Now, let's create an object from this class:

```lua
local class = ClassPP.class

local Car = class "Car" {
    Public = {
        Brand = "Lamborghini",
        getLicensePlate = function(self)
            print(self.License_Plate)
        end
    },
    Private = {
        License_Plate = "XXXX"
    }
}

local newCar = Car.new()
newCar:getLicensePlate()
```

You might have noticed that we always call the `getLicensePlate` with the `:` (colon) operator. This is a syntax sugar that we use to pass the object itself as the first argument to a function. Calling a function with the `:` operator is equavelent to calling it like `object.method(object)`, but it makes our job easier because we don't have to manually pass the object.

Due to this, the first argument of a function will always be what we call `self`, that is a pointer to the object. We use it to access the object's properties and functions from a class function.

### Functions with multiple parameters 

```lua
local class = ClassPP.class

local Car = class "Car" {
    Public = {
        Brand = "Lamborghini",
        setLicensePlate = function(self, newPlate)
            self.License_Plate = newPlate 
        end,
        getLicensePlate = function(self)
            return self.License_Plate
        end
    },
    Private = {
        License_Plate = "XXXX"
    }
}

local newCar = Car.new()
newCar:setLicensePlate("A1B2C3") -- Calling the function with an argument
print(newCar:getLicensePlate()) -- Prints "A1B2C3"!
```

In the example above, we added a new function called `setLicensePlate` that updates the private member `License_Plate` with the provided `newPlate` parameter. Then we used the now updated function `getLicensePlate` to access the private member `License_Plate` again to print the now updated value of the member. As you can see here, you can call the class functions with multiple parameters easily. <br>

You can also notice that since the `self` is the first argument, all the other arguments that come after will start at 2.

## Outside Class Definition

To define a function outside of the class, you must define it as: <br>`function Class.<accessSpecifier>:<functionName>`

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

function Car.Public:getLicensePlate(number)
    print(self.License_Plate, number) -- Prints "XXXX 1"!
end

local newCar = Car.new()
newCar:getLicensePlate(1)
```

In this example, we defined a function outside of the class by specifying the class name, then the access specifier, followed by the `:` operator and the name of the function. Unlike in some other OO languages, you do not have to define the function inside the class first to use this method.

!!! info
    Outside Class Definition syntax is recommended as it allows for a better formatting style.
