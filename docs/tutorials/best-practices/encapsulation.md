# Encapsulation

Encapsulation is a fundamental concept in OOP that combines data (properties) and methods (class functions) that work with that data into a single unit known as a class. This protective layer around the data allows it to maintain its integrity and prevents unauthorized access.

For example, imagine a coffee machine. A coffee machine has a grinder, brewer, and many other internal components that allows it to function. But you don't need to know how it works, you only need to know which buttons to press to get your coffee. This is similar to how it works in OOP.

----

## Why Encapsulation?

* **Data Protection**: By making the data private, you hide it from the outside world. Therefore, you protect it from accidental or intentional modifications from outside the class, ensuring its integrity. It also protects sensitive information.
* **Data Validation**: It allows you to ensure that the given data to the class is valid, and thus allowing for a safer system.
* **Increased Maintainability**: By controlling the access, any internal implementation changes are less likely to effect other external parts of the program.
* **Increased Flexibility**: It also allows for a cleaner interface, and due to the internal parts being private, the interface can be reused effectively. 

----

## Implementation

```lua
local class = ClassPP.class

local Student = class "Student" {
    Public = {
        -- Getter method for name
        getName = function(self)
            return self.Name
        end,

        -- Setter method for name
        setName = function(self, name)
            self.Name = name
        end,

        -- Getter method for age
        getAge = function(self)
            return self.Age
        end,

        -- Setter method for age
        setAge = function(self, age)
            if age > 0 then
                self.Age = age
            end
        end
    },

    Private = {
        Name = "",
        Age = 0
    }
}
```

In the example above, the `Student` class has private members called "Name" and "Age". The setter for the member "Age" includes a basic validation check. Using these getter and setter methods, we are able to access the values for these members.

----

## Tips

If you want to implement encapsulation, make sure all the important data are set as private, to protect them from external modification.
Using getter and setter methods for that data will allow for a much safer experience while allowing flexibility in changing the internal implementation. Like in the example on the previous section, also implementing validation checks will greatly improve data integrity.






