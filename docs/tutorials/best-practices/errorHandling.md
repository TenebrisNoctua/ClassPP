# Error Handling

Class++ is designed in a way that makes class and object access safe and optimized. But unfortunately, it cannot stop errors occuring in your program altogether. For example, it cannot stop you from trying to access private or non-existent data.

So it is up to you to be able to deal with the errors that occur while the program is running.

----

## Error Types

In Class++ there are two types of errors that can occur during runtime: Fatal and Non-Fatal.

### Fatal Errors

Fatal errors are the type of errors that will completely crash your program. These errors are the most dangerous ones, naturally.

!!! info
    Fatal errors in Luau can normally be created by using the built-in `error()` function:
    
    ```luau
    error("This will error!") -- Halts the execution, and prints the stack to the output.
    ```

In Class++, a fatal error will occur if you encounter a set limitation. For example, if you try to access a private member outside of a class method, it will cause a fatal error.

```luau
-- Assuming this is the main thread of the script.
local newObject = class.new()
newObject.PrivateProperty = "Hello!" -- Will cause a fatal error.
```

----

### Non-Fatal Errors

Non-Fatal errors are the type of errors that will not crash your program. While less dangerous, this still does not mean that your program will continue to work as expected. For example, if a `destructor` function fails to run, Class++ will still destroy the object, while ensuring the program keeps running. But this does not mean that destructor has ran correctly, and there might be an object or a system that could not be cleared up, thus causing a memory leak.

```luau
local newClass = class "Test" {
    destructor = function(self)
        error("An unknown error occured!")
        self.object:Destroy() -- This line will never be reached, causing the object to never be destroyed!
    end,
    Public = {
        object = {}
    }
}
```

----

## Tips

Be careful. To ensure your program is running safely, every operation that can fail should be put inside either a `pcall()` or a `xpcall()`. These functions allow you to safely handle any errors that may occur in your code.

*A full list of fatal and non-fatal errors can be found in the [Errors](../../api-reference/errors.md) page.*