<h1 class="api-header" markdown>
    <span class="api-icon" markdown>:octicons-package-24:</span>
    <span class="api-title">Class</span>
</h1>

A `class` object created from the [`class()`](../classFunctions/mainModule/class.md) function. Contains all of the members given from the [`classData`](../types/classData.md).

----------------------

<!------------------------- SUMMARY -------------------------!-->

<div class="api-summary-list">
    <h3 class="api-summary-list-h3">Summary</h3>
    <div class="api-summary-section">
        <h3 class="api-summary-section-h3">Properties</h3>
        <div class="api-summary-section-list">
            <ul>
                <li><a href="#name-string">Name</a>: An unique identifier of the <code>class</code>.</li>
                <li><a href="#inherits-class-read-only">Inherits</a>: A table that contains classes that the <code>class</code> inherits from.</li>
                <li><a href="#friends-class-read-only">Friends</a>: A table that contains functions or clases that can access the <code>Private</code> and the <code>Protected</code> members of the <code>class</code>. </li>
                <li><a href="#statics-string-any-read-only">Statics</a>:  A table that contains the static members of the <code>class</code>. These members can only be called through the <code>class</code> object.</li>
            </ul>
        </div>
    </div>
    <div class="api-summary-section-bottom">
        <h3 class="api-summary-section-h3">Methods</h3>
        <div class="api-summary-section-list">
            <ul>
                <li><a href="#new-object">new</a>:  Returns a new <code><a href="../object">object</a></code> that contains all of the members given from the <code>class</code>.</li>
                <li><a href="#extends-void">extends</a>: Used to create a new <code>class</code> that inherits the <code>class</code> it's been created from. <b><i>(Deprecated)</i></b></li>
                <li><a href="#overload-void">overload</a>: Creates an overloaded function with the given access specifier, name and the function table, and saves it to the <code>class</code>'s <code>classData</code>.</li>
            </ul>
        </div>
    </div>
</div>

----------------------

<!------------------------- MAIN -------------------------!-->

## Properties

<h3 markdown>
	Name
	<span class="api-property-type">
		: string
	</span>
</h3>

This is an unique identifier of the `class`. Using the [`getClass()`](../classFunctions/mainModule/getClass.md) function with this property will retrieve the desired `class`. Since names are unique, for every class, you have to use a different name.

----------------------

<h3 markdown>
	Inherits
	<span class="api-property-type">
		: {class}
	</span>
    <div class="api-access-type" style="float: none">Read Only</div>
</h3>

This table contains all the classes that the `class` is inheriting from. 

----------------------

<h3 markdown>
	Friends
	<span class="api-property-type">
		: {class}
	</span>
    <div class="api-access-type" style="float: none">Read Only</div>
</h3>

This table contains all the functions and the classes that can access all of the `Public` and `Protected` members of the `class`.

----------------------

<h3 markdown>
	Statics
	<span class="api-property-type">
		: {[string]: any}
	</span>
    <div class="api-access-type" style="float: none">Read Only</div>
</h3>

This table contains all the members that are static, meaning they only belong to the `class`. These members won't replicate to the 
objects, and can only be called through the `class` object.

----------------------

## Methods

<h3 markdown>
	new
	<span class="api-property-type">
		: object
	</span>
</h3>

Creates and returns a new [`object`](object.md) that contains all of the members given from the `class`.

#### Returns
<span markdown>
    <div class="md-typeset__table">
        <table>
            <tbody>
                <tr>
                    <td class="api-return-box"><a href="../object">object</a></td>
                </tr>
            </tbody>
        </table>
    </div>
</span>

----------------------

<h3 markdown>
	extends
	<span class="api-property-type">
		: void
	</span>
</h3>

Used to create and return a new `class` that inherits the `class` it's been created from.

!!! failure "Deprecated"
    This method has been deprecated and should not be used for new work.
    Instead, use the <a href="../../classFunctions/mainModule/class/"><code>class</code></a> method.

----------------------

<h3 markdown>
	overload
	<span class="api-property-type">
		: void
	</span>
</h3>

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
</span>

----------------------

<h3 markdown>
	static
	<span class="api-property-type">
		: void
	</span>
</h3>

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
</span>
