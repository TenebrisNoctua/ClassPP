<h1 class="api-header" markdown>
    <span class="api-icon" markdown>:octicons-circle-slash-24:</span>
    <span class="api-title">Errors</span>
</h1>

When Class++ displays an error message to the output, it will have a short ID at the end. This allows you to identify what kind of error or message that is.

You can use that ID to find the details about that error or message down below.

----

## attemptToCreateObjectFromAbstractClass

```
Cannot create an object from an abstracted class.
```

You tried to create an `object` from an abstract `class`. Abstract classes are not meant to create objects from, rather, they are meant to be a base-class that a `class` inherits from.

----

## attemptToExtendAFinalClass

```
Cannot create an inherited class from a final class.
```

You tried to create a `class` from a final `class`. Final classes are not meant to be inherited from.

----

## cannotCallFunctionError

```
Cannot call function ... directly.
```

You've tried to call a function within a `class` without creating an `object`. Class functions are not meant to be used directly, rather, they are to be used from objects. *(Excluding static members.)*

----

## cannotCallFunctionFrom

```
Cannot call function ... from ...
```

You've tried to call a function within an `object` that cannot be called within certain functions, such as `super()` in `destructor`.

----

## cannotFindBaseClassMethod

```
Property ... cannot be found or is not a function in the base class ...
```

You've tried to call a property with `super()` in the base `class` that cannot be found, or wasn't a function.

----

## classAlreadyExists

```
Class ... already exists.
```

You've tried to create a `class` that already has been created with the same name. Consider changing the name of the new `class`.

----

## classDataNotTable

```
Given classData value for the class ... is not a table.
```

You've given a `classData` value that is not a table to the `class` function. The `class` function only takes a table as its `classData` parameter.

----

## classDataContainsMetatable

```
Given classData value for the class ... contains a metatable.
```

You've given a `classData` value that contains a metatable attached to it. For security and performance reasons, `classData` parameter only takes a raw table without any metatables attached to it.

----

## classMemberCannotSetToNil

```
Class members cannot be set to nil.
```

You've attempted to set a class member within the `object` to nil. Setting member values to nil causes certain bugs to happen *(due to the nature of dictionaries)*, so it is not allowed to set them to `nil.` Consider setting it to a value such as `false` to indicate that it is no longer in use.

----

## classMemberNotFound

```
This class has no member named ...
```

You've tried to index the `object` with a member that does not exist within the `classData` table. Members can only be added or removed through changing the `classData` table given to the `class` function.

----

## classNameNotString

```
Class name is not a string or is nil.
```

The `class` function expected a `string` as it's name, but you provided something else. A `class`'s name can only be a `string`. 

----

## classNotFound

```
A class with the given name cannot be found.
```

A `class` cannot be found with the provided name argument. Make sure the name is correct, or if the `class` actually exists.

----

## classNoMatchingFunctionError

```
No match for ... function in this class.
```

You've used an operator on an `object` which had no overloads set for it.

----

## classObjectLocked

```
This class object has been locked.
```

You've tried to use an `object` after it's been locked.

----

## classPropertyIsPrivate

```
Property ... is private in this class.
```

You've tried to access a private member of an `object` outside of a class function.

----

## classPropertyIsProtected

```
Property ... is protected in this class.
```

You've tried to access a protected member of an `object` outside of a class function.

----

## classPropertyIsInternal

```
Property ... is internal in this class. It is inaccessible.
```

You've tried to access an internal member of an `object`. Internal members are not accessible.

----

## classPropertyRedeclaration

```
Cannot redeclare property ...
```

You've tried to declare a property that has already been declared in another access-specifier. You can only declare a member in one access-specifier.

----

## classTypeMismatch

```
The class type ... does not match with the intended class type ...
```

You've tried to call a reserved function (`:Destroy()`, `:super()`) of a class without the intended class type for that function. This error occurs because the reserved functions can only be used with objects that belong to the class they're created from. 

----

## expectedTypeError

```
Expected ..., got: ...
```

A function expected a certain type, but got something different instead. This may occur in cases where the data you provided is wrong or contains invalid values.

----

## extendsRemoved

```
Extends has been removed. Use the "class" function instead.
```

You've tried to use the now removed `extends` function for inheritance.<br>
See the discussion [`#4`](https://github.com/TenebrisNoctua/ClassPP/discussions/4) for more info.

----

## invalidAccessSpecifierError

```
Given value is not a valid access specifier.
```

You've provided a value that wasn't a valid access specifier. Make sure the given `string` contains a valid access-specifier. 

----

## invalidAccessSpecifierInClassData

```
Given classData value for the class ... contains invalid access specifier(s) or function(s).
```

You've given a `classData` value that contains invalid access-specifiers or functions. Make sure the access-specifier or function names are correct.

----

## invalidClassNewIndex

```
Cannot set a new property for the class ... that is an invalid access specifier or a function.
```

You've tried to set a new property for a class that wasn't a valid access specifier or a function. If you wish to add new members, you must do so within an access specifier.

----

## invalidConstructor

```
The current function does not match with a valid constructor function in the class ..., or within its inherited classes.
```

This error occurs if `:super()` cannot find a matching constructor function within the class it's been called from, or within its inherited classes. Make sure to call `:super()` from the correct constructor function.

----

## invalidDestructorCall

```
Cannot call Destroy without an object argument. Try calling the function with the ':' operator.
```

You've tried to call the `Destroy()` without providing the `object` as its first argument. Calling it with a ':' like `:Destroy()`, passes the `object` argument automatically.

----

## invalidInheritation

```
Cannot call super in a multi-inherited class, or in a non-inherited class.
```

You've tried to call `:super()` within a multi-inherited class, or in a non-inherited class. `:super()` only works within classes that inherit only one class.

----

## invalidModifierArgument

```
Given argument is not a class table.
```

You've given a value to a modifier function that wasn't a table containing classes.

----

## invalidPropertyDecleration

```
Cannot create reserved property ...
```

You've tried to create a reserved property in a `class`.<br>
Some property names are reserved for certain functions that come by default for every `object`, so you cannot declare them inside the `classData` value.

----

## invalidSuperCall

```
Cannot call super without an object argument. Try calling the function with the ':' operator.
```

You've tried to call `:super()` without providing an object argument. The first argument must always be the `object` that `:super()` is bound to.

----

## illegalModifierCombination

```
Cannot create an illegal combination of modifiers: ...
```

You've tried to create an illegal combination of modifiers. Certain modifiers have opposite functionality, so combining them is not possible.

----

## nonProvidedGlobal

```
Current runtime does not provide global ..., please ensure it exists.
```

The current runtime that Class++ is running on does not provide the requested global. Make sure that the global exists and provides the functionality that Class++ expects from it.

----

## overloadfunctionArgumentMismatch

```
A function to handle the given number of arguments ... have not been provided for the overloaded function: ...
```

You haven't provided a function to the `functionsTable` to handle the given number of arguments for an overloaded function.

----

## overloadfunctionNameNotSet

```
A function name has not been set for the overloaded function.
```

You haven't provided a name for the overloaded function.

----

## overloadfunctionTableNotGiven

```
A function table has not been given for the overloaded function.
```

You haven't provided a `functionsTable` for the overloaded function.

----

## staticMemberNameNotSet

```
A name has not been set for the static member.
```

You haven't provided a name for the static member.

----

## typeofObjectNotFound

```
The given object's type cannot be found.
```

The provided object's type cannot be found.

----

## unhandledError

```
An unhandled error occured in "...": ...
```

An unhandled error has occured in a specific function given to Class++. This error does not halt the execution of the thread, so be mindful of the bugs that may occur in your code.

----

## unknownError

```
An unknown error has occured.
```

Class++ ran into a problem, but it cannot associate it with a valid error type. This is meant to be a fallback error, and may only occur if the internal code isn't running properly.





