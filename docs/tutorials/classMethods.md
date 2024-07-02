# Class Functions

Just like in C++, there are two ways to define a function(method) inside a class:

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

Functions inside a class will always have `self` as their first argument. You can think of `self` as a pointer to the object. You can use it to access the object itself.

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

You can notice that instead of calling the function with `.` operator, we used `:` operator. This is because of the first argument always being `self`. Calling the function with a `.` operator will cause the `self` to not exist, so you must either call the function with the object as its first argument, or use `:` operator, as it makes it easier.

### Functions with multiple parameters 

```lua
local class = ClassPP.class

local Car = class "Car" {
    Public = {
        Brand = "Lamborghini",
        getLicensePlate = function(self, number)
            print(self.License_Plate, number) -- Prints "XXXX 1"
        end
    },
    Private = {
        License_Plate = "XXXX"
    }
}

local newCar = Car.new()
newCar:getLicensePlate(1) -- Calling the function with an argument
```

Like in this example, you can call functions with multiple parameters. <br> 
Since `self` is the first argument, all the other arguments that come after will start at 2. This will be important in later pages.

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
    print(self.License_Plate, number) -- Prints "XXXX 1"
end

local newCar = Car.new()
newCar:getLicensePlate(1)
```

In this example, we defined a function outside of the class by specifying the class name, then the access specifier, followed by the `:` operator and the name of the function. Unlike in C++, you do not have to define the function first inside the class to use this method.

!!! info
    For better formatting of your classes, this method is recommended.
