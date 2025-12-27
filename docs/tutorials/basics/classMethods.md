# Class Functions

So far, we have only created simple members that hold simple values, what about *functions*?

Just like in other object oriented languages, there are two ways to define a function *(method)* inside a class:

* Inside class definition
* Outside class definition

!!! info
    Class Functions are also called Class Methods, and we will use this term from now on in later pages of the tutorials.

## Inside Class Definition

```luau
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

In this example, we have defined a new function inside the public access specifier called `getLicensePlate`, this function when called will print the license plate of our object. 

Now, let's create an object from this class:

```luau
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

You might have noticed that we've called the `getLicensePlate` function with the `:` (colon) operator. This is a syntax sugar that we use to pass the object itself as the first argument to a function. Calling a function with the `:` operator is equivalent to calling it like `object.method(object)`, but it makes our job easier because we don't have to manually pass the object every single time when calling the function.

Due to this, the first argument of a function will always be what we call `self`, that is a pointer to the object. We use it to access the object's properties inside the function.

### Functions with multiple parameters 

```luau
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

In the example above, we added a new function called `setLicensePlate` that updates the private member `License_Plate` with the provided `newPlate` parameter. We've also updated the `getLicensePlate` function to return the private member `License_Plate`, which we then use to print the now updated value of the member. Make sure to remember that `self` should always be the first parameter, and all the other parameters should come after it.

## Outside Class Definition

You're not limited to always defining functions inside of the `classData` itself. You can also define it outside of the `classData`, by using the method shown below.

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

function Car.Public:getLicensePlate(number) -- You should always define a function through the Class.AccessSpecifier:FunctionName syntax.
    print(self.License_Plate, number) -- Prints "XXXX 1"!
end

local newCar = Car.new()
newCar:getLicensePlate(1)
```

In this example, we defined a function outside of the class by specifying the class name, then the access specifier, followed by the `:` operator and the name of the function.

### Typechecking

Unlike any other object oriented language such as C++, Class++ does not require you to define class functions inside the `classData` first to use the outside class definition method. However, it comes with certain disadvantages.

Unfortunately, defining class functions this way alone will not give you any intellisense when you're calling the function through the object.
This is due to the limitations of the Luau's typechecking system. So, to get around this, we define the class function first inside the `classData` with only its parameter types, and then using the outside class definition method, we define the actual body of the function outside of the `classData`.

```luau
local ClassPP = require('./ClassPP')
local class = ClassPP.class

local Car = class "Car" {
	Public = {
		Brand = "Lamborghini",
		getLicensePlate = function(number) end
	},
	Private = {
		License_Plate = "XXXX"
	}
}

function Car.Public:getLicensePlate(number)
	print(self.License_Plate, number) -- Still prints "XXXX 1"!
end

local newCar = Car.new()
newCar:getLicensePlate(1)
```

!!! success "Recommended"
    Outside Class Definition method with the syntax above is recommended as it allows for a better formatting style.