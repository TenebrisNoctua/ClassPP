# Error Handling

Class++ is designed in a way that prevents you from causing the most common errors, but it cannot stop you from causing errors altogether. It cannot stop you from trying to access private data or data that doesn't exist, for example.

So it is up to you to be able to deal with the errors that occur while the program is running.

----

## Error Types

In Class++ there are two types of errors that can occur during runtime: Fatal and Non-Fatal.

### Fatal Errors

Fatal errors are the type of errors that will completely crash your program. These errors are the most dangerous ones, naturally.

Fatal errors can normally be created by using the built-in `error()` function:

```lua
error("This will error!") -- Halts the execution, and prints the stack to the output.
```

In Class++, a fatal error will occur if you encounter a set limitation. For example, if you try to access a private property outside of a class method, this will cause a fatal error.

```lua
local newObject = class.new()
newObject.PrivateProperty = "Hello!" -- Will cause a fatal error.
```

----

### Non-Fatal Errors

Non-Fatal errors are the type of errors that will not crash your program. While less dangerous, this still does not mean that your program will continue to work as expected. For example, if a `destructor` function fails to run, Class++ will still destroy the object, while ensuring the program keeps running. But this does not mean that destructor has ran correctly, and there might be an object or a system that could not be cleared up, thus causing a memory leak.

```lua
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