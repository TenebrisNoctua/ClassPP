<h1 class="api-header" markdown>
    <span class="api-icon" markdown>:octicons-package-24:</span>
    <span class="api-title">Object</span>
</h1>

An `object` created from the [`class.new()`](class.md#new-object) function. Contains all of the members given from the `class` object.

!!! warning
    `object`s act as a proxy, as they belong to the base type `userdata`. They allow access to members in the `objectData`, but they cannot be changed. This is to make access-specifiers work in the best way possible.

----------------------

<!------------------------- SUMMARY -------------------------!-->

<div class="api-summary-list">
    <h3 class="api-summary-list-h3">Summary</h3>
    <div class="api-summary-section">
        <h3 class="api-summary-section-h3">Properties</h3>
        <div class="api-summary-section-list">
            <ul>
                <li><a href="#__locked-boolean-internal">__locked</a>: Indicates if the <code>object</code> is locked.</li>
                <li><a href="#__type-string-internal">__type</a>: Indicates the type of the <code>object</code>.</li>
                <li><a href="#__objtype-string-internal">__objtype</a>: Indicates the <code>class</code> type of the <code>object</code>.</li>
            </ul>
        </div>
    </div>
    <div class="api-summary-section-bottom">
        <h3 class="api-summary-section-h3">Methods</h3>
        <div class="api-summary-section-list">
            <ul>
                <li><a href="#constructor-void-internal">constructor</a>: The constructor function of the <code>object</code>, if it exists. Cannot be directly called.</li>
                <li><a href="#destructor-void-internal">destructor</a>: The destructor function of the <code>object</code>, if it exists. Cannot be directly called.</li>
                <li><a href="#destroy-void">Destroy</a>: Calls the <code>destructor</code> function, destroys all the instances inside the <code>objectData</code> and clears it, and sets the <code>__locked</code> property to <code>true</code>.</li>
                <li><a href="#super-any">super</a>: Calls the method with the same name of the function that it's been called from in the parent <code>class</code>, if it exists.</li>
            </ul>
        </div>
    </div>
</div>

----------------------

<!------------------------- MAIN -------------------------!-->

## Properties

<h3 markdown>
	__locked
	<span class="api-property-type">
		: boolean
	</span>
    <div class="api-access-type" style="background-color: rgb(113, 25, 66); float: none">Internal</div>
</h3>

Indicates if an `object` has been locked. If set to true, the `object`'s metamethods will no longer work and all the members will become unaccessable. 

----------------------

<h3 markdown>
	__type
	<span class="api-property-type">
		: string
	</span>
    <div class="api-access-type" style="background-color: rgb(113, 25, 66); float: none">Internal</div>
</h3>

Indicates the type of the `object`. For `object`s created from `class.new()`, it will always be "Object".

----------------------

<h3 markdown>
	__objtype
	<span class="api-property-type">
		: string
	</span>
    <div class="api-access-type" style="background-color: rgb(113, 25, 66); float: none">Internal</div>
</h3>

Indicates the `class` type of the `object`. Can be used to determine which `class` the `object` belongs to by using the [`Type.typeof()`](../classFunctions/type/typeof.md) function.

----------------------

## Methods

<h3 markdown>
	constructor
	<span class="api-property-type">
		: void
	</span>
    <div class="api-access-type" style="background-color: rgb(113, 25, 66); float: none">Internal</div>
</h3>

The `constructor` function of the `object`, if it has been set in the `classData` table. This function is internal, and it will only be called when the `object` is created by using the `class.new()` function.

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
	destructor
	<span class="api-property-type">
		: void
	</span>
    <div class="api-access-type" style="background-color: rgb(113, 25, 66); float: none">Internal</div>
</h3>

The `destructor` function of the `object`, if it has been set in the `classData` table. This function accepts no parameters and is internal, it will only be called when `object:Destroy()` is called. 

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
	Destroy
	<span class="api-property-type">
		: void
	</span>
</h3>

Calling this method will destroy and clean the `object`. This method will first trigger the `destructor` function, then after, it will clear the internal `objectData` table and set the `__locked` property of the `object` to `true`. Instances inside `objectData` will automatically be destroyed and cleared too.

After this function runs, the `object` will no longer be accessible in any way, so make sure to remove all references to the `object` to allow for the garbage collector to clear it. This prevents memory leaks.

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
	super
	<span class="api-property-type">
		: any
	</span>
</h3>

This method allows you to refer to the parent `class`'s methods. Calling this method will call the function with the same name as the function it's been called from in the parent `class`, if it exists, and return the result.

!!! warning
    `super` does not support being called in `class`es created from multi-inheritance, as it would create ambiguity. It also does not support calling functions that are defined in the `Private` access-specifier in the parent `class`.