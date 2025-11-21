# Optimization

Class++ is designed to be as optimized as possible for a class and objects system. To achieve the best performance, you can avoid certain scenarios that will slow Class++ down.

----

## Skipping Operations

Class++ will skip certain unnecessary operations made by the user. For example, if you try to set a value to a member that is exactly the same as the one the member had before, Class++ will skip this operation.

```lua
local newClass = class "Test" {
    Public = {
        test = "hello"
    }
}

local newObject = newClass.new()
newObject.test = "hello" -- This operation will be skipped.
```

However, you still shouldn't trust on Class++ to skip these operations, as it will still try to check if the thread is able to access the member or not. To get the best performance, avoid setting member values to the same values as before.

----

## Accessing Members

Now, accessing members in Class++ is *very fast\**, and you should not worry about performance. However, if you still want to gain the best amount of performance, here are some things you can do:

1. Always access private members from class functions.<br>
This allows Class++ to achieve the best performance when achieving the member values. This also supports [encapsulation](encapsulation.md), and will encourage you to adopt coding styles that will be the best for you in the long-run.
2. Use public members when necessary.<br>
If a member does not contain important data or is an interface, then it should be a public member. This greatly increases the performance when accessing that member, and also promotes a better coding style.

----

Class++ is very flexible and tries to be as lightweight as possible. Always avoid using systems or patterns that will both slow Class++, and your own methods down. You can check out other pages of the Tutorial to adapt the recommended patterns and syntax.

----
<h6>*: About 3 μs (3 microseconds)</h6>