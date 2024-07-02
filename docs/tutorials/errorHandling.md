# Error Handling

In Class++, there are some errors to be cautious of. Some limitations exist, and when you encounter an error, Class++ will try to tell you what that happened. But sometimes that might not be enough, so this page serves as a tutorial on how to troubleshoot some very important errors that you might encounter.

## "Given ClassData value is not a table." & "Given ClassData value contains a metatable."

When you're creating a class, always make sure that the top `classData` table that you're giving to the `class()` function is a raw table. 
It must not contain a metatable, as classes are designed to be secure, adding a metatable to the `classData` will cause very important security problems. Attempting to give a value that's not a table or giving a table that contains a metatable will cause this error.

## "Cannot redeclare property ..."

This error was mentioned in one of the previous pages, but I think it needs some mention here. In Class++, access specifiers are not tables that you can declare the same member in. For example, let's say you created a member called `Name` in the `Public` access specifier, you cannot create `Name` again in the `Private` or `Protected` access specifiers. They're access specifiers after all, not different tables that you can use like this. Attempting to declare a member that's already been declared in an access specifier before will cause this error.

## "A function to handle the given number of arguments ... have not been provided for the overloaded function: ..."

This error occurs when you call an overloaded function with amount of arguments that do not correspond to a function in the given `functionTable`. For example, if you have an overloaded function, but do not have a specific function to handle 4 arguments, this error will occur.

## "Cannot call function directly."

When you try to call a function inside a class directly, this error will occur. Classes are meant to be blueprints for an object, they cannot be used directly. Attempting to call a function inside a class and not through the object will cause this error.