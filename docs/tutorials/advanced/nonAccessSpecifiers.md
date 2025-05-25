# Non-Access Specifiers

Unlike access specifiers, non-access specifiers do not modify the access control of a member, but rather provide other functionality for classes.

## Final 

Using this non-access specifier will make the given class final, meaning this class now cannot be inherited by other classes.

```lua
local class, final = ClassPP.class, ClassPP.final

local Car = final { class "Car" {
	Public = {
		Brand = "Ford",
	}
}}

local BiggerCar = class "BiggerCar" (Car, nil) { -- This will error!
	Public = {
		Brand = "Tesla"
	}
}
```

## Abstract 

Using this non-access specifier will make the given class an abstract class, meaning this class now cannot be used to create objects.
To access an abstract class's members, you need to create a class that inherits from this abstract class.

```lua
local class, abstract = ClassPP.class, ClassPP.abstract

local BaseCar = abstract { class "BaseCar" {
	Public = {
		Brand = "",
		Model = "",
		Year = 0,
		honk = function(self)
			print("honk honk!")
		end
	}
}}

local Car = class "Car" (BaseCar, nil) {
	Public = {
		Brand = "Ford",
		Model = "Mustang",
		Year = 2023
	}
}

local newBaseCarObj = BaseCar.new() -- This will error!
local newCarObj = Car.new() -- This will work fine!
newCarObj:honk()
```

!!! warning
    You cannot make a class both abstract and final, as they have opposite meanings. An abstract class must be subclassed, whereas a final class cannot be subclassed. Attempting to form an illegal combination between final and abstract methods will cause an error.
