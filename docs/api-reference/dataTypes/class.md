<h1 class="api-header" markdown>
    <span class="api-icon" markdown>:octicons-package-24:</span>
    <span class="api-title">Class</span>
</h1>

A `class` object created from the [`class()`](../classFunctions/mainModule/class.md) function. Contains all of the members given from the [`classData`](../types/classData.md).

<div class="api-summary-list">
    <h3 style="api-summary-list-h3">Summary</h3>
    <div style="api-summary-section">
        <h3 style="api-summary-section-h3">Properties</h3>
        <div style="api-summary-section-list">
            <ul>
                <li><a href="#Name">Name</a></li>
                <li><a href="#Inherits">Inherits</a></li>
                <li><a href="#Friends">Friends</a></li>
                <li><a href="#Statics">Statics</a></li>
            </ul>
        </div>
    </div>
    <div style="api-summary-section">
        <h3 style="api-summary-section-h3">Methods</h3>
        <div style="api-summary-section-list">
            <ul>
                <li><a href="#new">new</a></li>
                <li><a href="#extends">extends</a></li>
                <li><a href="#overload">overload</a></li>
            </ul>
        </div>
    </div>
</div>

<!------------------------- PROPERTIES -------------------------!-->

<h3 markdown="1" class="apiReferenceSummaryTitle"> Properties </h3>

&nbsp;[Name](#name) : <a href="https://create.roblox.com/docs/luau/strings" style="color: lightskyblue;">string</a>

&nbsp;An unique identifier of the `class`.

----------------------

<div>&nbsp;<a href="#inherits">Inherits</a> : <a href="https://create.roblox.com/docs/luau/tables" style="color: lightskyblue;">Table</a><div class="apiReferenceAccessBox">Read Only</div></div>

&nbsp;A table that contains classes that the `class` inherits from.

----------------------

<div>&nbsp;<a href="#friends">Friends</a> : <a href="https://create.roblox.com/docs/luau/tables" style="color: lightskyblue;">Table</a><div class="apiReferenceAccessBox">Read Only</div></div>

&nbsp;A table that contains functions or classes that can access `Private` and `Protected` members of the `class`.

----------------------

<div>&nbsp;<a href="#statics">Statics</a> : <a href="https://create.roblox.com/docs/luau/tables" style="color: lightskyblue;">Table</a><div class="apiReferenceAccessBox">Read Only</div></div>

&nbsp;A table that contains the static members of the `class`. These members can only be called through the `class` object.

<!------------------------- METHODS -------------------------!-->

<h3 markdown="1" class="apiReferenceSummaryTitle"> Methods </h3>

&nbsp;[new](#new) (...) : <a style="color: lightskyblue;">any</a>

&nbsp;Returns a new [`object`](object.md) that contains all of the members given from the `class`.

----------------------

&nbsp;[extends](#extends) (className: string) : (classData: classData) : <a style="color: lightskyblue;">class</a>

&nbsp;(Deprecated) Creates a new `class` that inherits the `class` it's been created from. Contains all `Public` and `Protected` members of that base `class`.

----------------------

&nbsp;[overload](#overload) (accessSpecifier: string, name: string, functionTable: {(...any) -> (any)}) : <a style="color: lightskyblue;">void</a>

&nbsp;Creates an overloaded function with the given access specifier, name and the function table, and saves it to the `class`'s `classData`.

----------------------

&nbsp;[static](#overload) (accessSpecifier: string, name: string, property: any) : <a style="color: lightskyblue;">void</a>

&nbsp;Creates a new static `class` member that can only be accessable through the `class` object. 

## Properties

### Name 
<a href="https://create.roblox.com/docs/luau/strings" style="color: lightskyblue;">string</a>

This is an unique identifier of the `class`. Using the [`getClass()`](../classFunctions/mainModule/getClass.md) function with this property will retrieve the desired `class`. Since names are unique, for every class, you have to use a different name.

----------------------

### Inherits
<a href="https://create.roblox.com/docs/luau/tables" style="color: lightskyblue;">Table</a>
<div class="apiReferenceAccessBox" style="float: none">Read Only</div>

This table contains all the classes that the `class` is inheriting from. Currently, multiple class inheritance is not supported, so a `class` can only inherit from one `class`, but it may be different in the future.

----------------------

### Friends
<a href="https://create.roblox.com/docs/luau/tables" style="color: lightskyblue;">Table</a>
<div class="apiReferenceAccessBox" style="float: none">Read Only</div>

This table contains all the functions and the classes that can access all of the `Public` and `Protected` members of the `class`.

----------------------

### Statics
<a href="https://create.roblox.com/docs/luau/tables" style="color: lightskyblue;">Table</a>
<div class="apiReferenceAccessBox" style="float: none">Read Only</div>

This table contains all the members that are static, meaning they only belong to the `class`. These members won't replicate to the 
objects, and can only be called through the `class` object.

## Methods

### new
<a style="color: lightskyblue;">any</a>

Creates and returns a new [`object`](object.md) that contains all of the members given from the `class`.

#### Returns
<span markdown>
    <div class="md-typeset__table">
        <table>
            <tbody>
                <tr>
                    <td class="api-return-box"><a href="object.md">object</a></td>
                </tr>
            </tbody>
        </table>
    </div>
</div>

----------------------

### extends
<a style="color: lightskyblue;">class</a>

Creates and returns a new `class` that inherits the `class` it's been created from. Contains all the `Public` and `Protected` members of that base `class`. 

----------------------

### overload
<a style="color: lightskyblue;">void</a>

Creates an overloaded function with the given parameters, and saves it to the `class`'s `classData` table.

#### Parameters
<span markdown>
    <div class="md-typeset__table">
        <table>
            <tbody>
                <tr>
                    <td class="api-param-highlight">accessSpecifier: <a href="https://create.roblox.com/docs/luau/strings">string</a></td>
                    <td>The access specifier of the overloaded function.</td>
                </tr>
                <tr>
                    <td class="api-param-highlight">name: <a href="https://create.roblox.com/docs/luau/strings">string</a></td>
                    <td>The name of the overloaded function.</td>
                </tr>
                <tr>
                    <td class="api-param-highlight">functionTable: <a href="https://create.roblox.com/docs/luau/tables">{(...any) -> (any)}</a></td>
                    <td>The function table that contains all the functions with different amount of arguments for the overloaded function.</td>
                </tr>
            </tbody>
        </table>
    </div>
</span>

#### Returns
<span markdown>
    <div class="md-typeset__table">
        <table>
            <tbody>
                <tr>
                    <td class="api-return-box">void</td>
                </tr>
            </tbody>
        </table>
    </div>
</div>

----------------------
<!--
### static
<a style="color: lightskyblue;">void</a>

Creates a new static member with the given parameters, and saves it to the `class`'s `Statics` table. These members do not replicate to the objects, as they belong to the `class`. 

#### Parameters
<span markdown>
    <div class="md-typeset__table">
        <table>
            <tbody>
                <tr>
                    <td class="api-param-highlight">accessSpecifier: <a href="https://create.roblox.com/docs/luau/strings">string</a></td>
                    <td>The access specifier of the static member.</td>
                </tr>
                <tr>
                    <td class="api-param-highlight">name: <a href="https://create.roblox.com/docs/luau/strings">string</a></td>
                    <td>The name of the static member.</td>
                </tr>
                <tr>
                    <td class="api-param-highlight">property: <a href="https://create.roblox.com/docs/luau/type-checking#types">any</a></td>
                    <td>The property that will be saved to the static member. This property can then be accessed through indexing the <code>class</code> with the member name, such as: <code>class.memberName.property</code>. (Or <code>class.memberName.p</code>)</td>
                </tr>
            </tbody>
        </table>
    </div>
</span>

#### Returns
<span markdown>
    <div class="md-typeset__table">
        <table>
            <tbody>
                <tr>
                    <td class="api-return-box">void</td>
                </tr>
            </tbody>
        </table>
    </div>
</div>
-->