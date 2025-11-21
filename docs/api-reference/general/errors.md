<h1 class="api-header" markdown>
    <span class="api-icon" markdown>:octicons-circle-slash-24:</span>
    <span class="api-title">Errors</span>
</h1>

When Class++ displays an error message to the output, it will have a short ID at the end. This allows you to identify what kind of error or message that is.

You can use that ID to find the details about that error or message down below.

----

## attemptToModifyReadOnlyTable

```
Cannot modify a read only table.
```

You've attempted modify a read-only table within Class++. This usually occurs when you try to modify the [`Inherits`](../../data-types/class/#inherits-class-read-only), [`Friends`](../../data-types/class/#friends-class-read-only) and [`Statics`](../../data-types/class/#statics-string-any-read-only) tables of a `class`.

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

## classClassDataInternal

```
The property classData of the class ... is Internal. It cannot be used.
```

You've attempted to access the `classData` property of a `class` directly. This property is meant to be used internally, and is not meant for external use. This property only shows up in the auto-complete to support type-checking in certain cases.

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
Property ... is internal in this class. You cannot access it.
```

You've tried to access an internal member of an `object`. Internal members are not accessible.

----

## classPropertyRedeclaration

```
Cannot redeclare property ...
```

You've tried to declare a property that has already been declared in another access-specifier. You can only declare a member in one access-specifier.

----

## expectedFunctionError

```
Expected function, got: ...
```

The `functionsTable` that you provided to `class.overload` function had a value that wasn't a function.

----

## extendsDeprecated

```
Extends is now deprecated. Use the "class" function instead.
```

You've tried to use the now deprecated `extends` function for inheritance.<br>
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

## invalidDestructorCall

```
Cannot call Destroy without an object argument. Try calling the function with the ':' operator.
```

You've tried to call the `Destroy()` without providing the `object` as its first argument. Calling it with a ':' like `:Destroy()`, passes the `object` argument automatically.

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
Cannot call super in a multi-inherited class, or in a non-inherited class.
```

You've tried to call the `super()` function from a `class` that either wasn't inheriting from another `class`, or it was inheriting from multiple `class`es. 

----

## illegalModifierCombination

```
Cannot create an illegal combination of modifiers: ...
```

You've tried to create an illegal combination of modifiers. Certain modifiers have opposite functionality, so combining them is not possible.

----

## nonNativeOperatorCall

```
Operator function ... cannot be called without its operator.
```

You've tried to call an operator function without its operator. Operator functions are meant to be called with their operators.

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





