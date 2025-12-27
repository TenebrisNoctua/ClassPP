# Composition

Composition is another fundemental concept in OOP that combines objects or data types into more complex ones.
This implements a *has-a* relationship between objects, rather than *is-a* from [Inheritance](../advanced/inheritance.md).

For example, let's imagine a coffee machine. This coffee machine **has a** grinder, a brewer, and many other components, but the coffee machine itself *is not one of them*.

```luau
local GroundCoffee = class "GroundCoffee" {}
local Coffee = class "Coffee" {}

local Grinder = class "Grinder" {
	Public = {
		grind = function(self)
			-- Grinds the coffee and returns a new GroundCoffee
			return GroundCoffee.new()
		end,
	}
}

local BrewingUnit = class "BrewingUnit" {
	Public = {
		brew = function(self, groundCoffee)
			-- Brew the groundCoffee and return a new Coffee.
			return Coffee.new()
		end,
	}
}

local CoffeeMachine = class "CoffeeMachine" {
	constructor = function(self)
		self.Grinder = Grinder.new()
		self.BrewingUnit = BrewingUnit.new()
	end,
	Public = {
		brewCoffee = function(self)
			-- Brew the coffee using the grinder and the brewing unit of the object, and return it.
		end,	
	},
	Private = {
		Grinder = false,
		BrewingUnit = false
		-- Add other members to create a full coffee machine
	}
}
```
In the example above, we have `GroundCoffee` and `Coffee` classes which are used within the `Grinder` and `BrewingUnit` classes, and the `CoffeeMachine` class that uses them. As you can see in the example, `CoffeeMachine` only exposes a `brewCoffee` method, that brews a `Coffee` and returns it. (Implementation details are skipped for the sake of clarity.)

Like we have discussed in the [Encapsulation](encapsulation.md) page, by restricting access through only exposing a method to brew a coffee, we allow for data integrity, so we can be sure that `CoffeeMachine`'s `Grinder` and `BrewingUnit` objects will not change, and they cannot be accessed directly.

Maintainability is also increased, as if the implementation of the `Grinder`'s `grind` method ever changes, `CoffeeMachine` will not be affected. The same can be said for `BrewingUnit` as well.

----

## Composition Over Inheritance

Like we have mentioned in the [Inheritance](../advanced/inheritance.md) page, inheritance is a powerful way to achieve code reuse, but not always it is the best tool for the job. 

Inheritance may sometimes violate encapsulation. A derived class depends on the implementation details of its base class, so if the base class gets a change in its implementation, the derived class may break, even though its code hasn't been touched. Due to this, the derived class must also be updated alongside the base class, to ensure it works correctly.

```luau
local User = class "User" {
    Public = {
        login = function(self)
            print("User logged in.")
        end
    }
}

local Admin = class "Admin" (User, nil) {
    Public = {
        manageUsers = function(self) 
            print("Admin managing users.")
        end
    }
}

local Editor = class "Editor" (User, nil) {
    Public = {
        editContent = function(self) 
            print("Editor editing content.")
        end
    }
}

local Viewer = class "Viewer" (User, nil) {
    Public = {
        viewContent = function(self) 
            print("Viewer viewing content.")
        end
    }
}
```

In the example above, we have created a user hierarchy, where different types of users have different methods. <br>
The problems with this system, however are:

* If we want to create a new role, or a new ability, we need to create a new class.
* If certain roles share the same functions, it might even decrease code reusability.
* If we want to create a user with multiple roles, such as an `Admin` whos also an `Editor`, the system becomes even more complicated.

However, if we use composition over inheritance:

```luau
local Permission = class "Permission" {
    Public = {
        execute = function(self)
            -- Execute the permission, can be overwritten.
        end
    }
}

local ManageUsers = class "ManageUsersPermission" (Permission, nil) {
    Public = {
        execute = function(self)
            print("Managing users.")
        end
    }
}

local EditContent = class "EditContentPermission" (Permission, nil) {
    Public = {
        execute = function(self)
            print("Editing content.")
        end
    }
}

local ViewContent = class "ViewContentPermission" (Permission, nil) {
    Public = {
        execute = function(self)
            print("Viewing content.")
        end
    }
}

local User = class "User" {
    constructor = function(self, username) 
        self.Username = username
    end
    Public = {
        addPermission = function(self, permission) 
            table.insert(self.Permissions, permission)
        end,
        login = function(self) 
            print(self.Username + " logged in.")
        end,
        executePermissions = function(self)
            for _, permission in self.Permissions do
                permission:execute()
            end
        end 
    },
    Private = {
        Username = "",
        Permissions = {}
    }
}
```

In the example above, instead of mainly using inheritance, we used composition. In other words, instead of extending the users to create new classes, we extended permissions, that each can have different abilities and methods. This allowed us to create a very flexible `User` class that can have multiple permissions.

----

## Tips

Like you've seen in the examples above, composition over inheritance generally yields better results. However, this does not mean that inheritance holds no place in OOP, as in the above example when we created our permission classes, we still used inheritance.

This phrase from ["Effective Java"](https://kea.nu/files/textbooks/new/Effective%20Java%20(2017%2C%20Addison-Wesley).pdf) summarizes where you should use composition and inheritance very well: *"...a class B should extend a class A only if an “is-a” relationship exists between the two classes. If you are tempted to have a class B extend a class A, ask yourself the question: Is every B really an A? If you cannot truthfully answer yes to this question, B should not extend A. If the answer is no, it is often the case that B should contain a private instance of A and expose a different API: A is not an essential part of B, merely a detail of its implementation."*
