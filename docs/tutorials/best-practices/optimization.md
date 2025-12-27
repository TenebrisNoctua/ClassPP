# Optimization

Class++ is designed to be as optimized as possible for a class and objects system. To achieve the best performance, you can avoid certain scenarios that will slow Class++ down.

----

## Skipping Operations

Class++ will skip certain unnecessary operations made by the user. For example, if you try to set a value to a member that is exactly the same as the one the member had before, Class++ will skip this operation.

```luau
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

Accessing members in Class++ is *very fast\**, and the performance overhead that Class++ causes should not be your primary concern. However, there are certain practices that you can apply to gain as much performance as possible out of Class++.

1. Always access private members from class functions.<br>
This allows Class++ to achieve the best performance when fetching the member values. This also supports [encapsulation](encapsulation.md), and will encourage you to adopt coding styles that will be the best for you in the long-run.
2. Use public members when necessary.<br>
If a member does not contain important data or is an interface, then it should be a public member. This greatly increases the performance when accessing that member, and once again promotes a better coding style.

----

Class++ tries to be as lightweight as possible. However, you should still try to avoid using systems or patterns that may impact the performance of your programs when using Class++. You can check out other sections of the tutorials to adapt the recommended patterns and syntax.

----
<h6>*: About 3 μs (3 microseconds)</h6>