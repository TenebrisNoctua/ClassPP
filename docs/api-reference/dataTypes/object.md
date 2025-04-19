# Object

An `object` created from the [`class.new()`](class.md#new) function. Contains all of the members given from the `class` object.

!!! warning
    An `object`'s `metatable` cannot be deleted or changed. This is to prevent access to the `Internal` members, logic that keeps the `object` secure, and the logic on how it works. An `object` will always belong to the base type `userdata`.

## Summary

<!------------------------- PROPERTIES -------------------------!-->

<h3 markdown="1" class="apiReferenceSummaryTitle"> Properties </h3>

<div>&nbsp;<a href="#__locked">__locked</a> : <a href="https://create.roblox.com/docs/luau/booleans" style="color: lightskyblue;">boolean</a><div class="apiReferenceAccessBox" style="background-color: rgb(113, 25, 66)">Internal</div></div>

&nbsp;Indicates if an `object` is locked. 

----------------------

<div>&nbsp;<a href="#__type">__type</a> : <a href="https://create.roblox.com/docs/luau/strings" style="color: lightskyblue;">string</a><div class="apiReferenceAccessBox" style="background-color: rgb(113, 25, 66)">Internal</div></div>

&nbsp;Indicates the `class` type of the `object`. 

-----------------------

<div>&nbsp;<a href="#objectdata">objectData</a> : <a href="https://create.roblox.com/docs/luau/tables" style="color: lightskyblue;">Table</a><div class="apiReferenceAccessBox" style="background-color: rgb(110, 40, 100)">No Direct Access</div></div>

&nbsp;The `object`'s data table that you can access by indexing the `object` with the member's name. (`object.member` or `object["member"]`)

<!------------------------- METHODS -------------------------!-->

<h3 markdown="1" class="apiReferenceSummaryTitle"> Methods </h3>

<div>&nbsp;<a href="#constructor">constructor</a> (...) : <a style="color: lightskyblue;">void</a><div class="apiReferenceAccessBox" style="background-color: rgb(113, 25, 66)">Internal</div></div>

&nbsp;The constructor function of the `object`, if it exists. Cannot be directly called.

----------------------

<div>&nbsp;<a href="#destructor">destructor</a> () : <a style="color: lightskyblue;">void</a><div class="apiReferenceAccessBox" style="background-color: rgb(113, 25, 66)">Internal</div></div>

&nbsp;The destructor function of the `object`, if it exists. Cannot be directly called.

----------------------

&nbsp;[Destroy](#destroy) () : <a style="color: lightskyblue;">void</a>

&nbsp;Calls the `object`'s `destructor` function, destroys all the instances inside the `objectData` and clears it, and sets the `__locked` property to `true`.

## Properties

### __locked 
<a href="https://create.roblox.com/docs/luau/booleans" style="color: lightskyblue;">boolean</a>
<div class="apiReferenceAccessBox" style="background-color: rgb(113, 25, 66); float: none">Internal</div>

Indicates if an `object` has been locked. If set to true, the `object`'s metamethods will no longer work and all the members will become unaccessable. 


### __type 
<a href="https://create.roblox.com/docs/luau/strings" style="color: lightskyblue;">string</a>
<div class="apiReferenceAccessBox" style="background-color: rgb(113, 25, 66); float: none">Internal</div>

Indicates the `class` type of the `object`. Can be used to determine which `class` the `object` belongs to by using the [`Type.typeof()`](../classFunctions/type/typeof.md) function.


### objectData 
<a href="https://create.roblox.com/docs/luau/tables" style="color: lightskyblue;">Table</a>
<div class="apiReferenceAccessBox" style="background-color: rgb(110, 40, 100); float: none">No Direct Access</div>

The `object`'s data table that stores every access specifier, and the members inside them. This data table cannot be accessed directly, so you have to index the `object` by using `object.member` or `object["member"]` methods to access it.

## Methods

### constructor
<a style="color: lightskyblue;">void</a>
<div class="apiReferenceAccessBox" style="background-color: rgb(113, 25, 66); float: none">Internal</div>

The `constructor` function inside the `object`, if it has been set in the `classData` table. This function is internal, so it will only be called when the `object` is created by using the `class.new(...)` function.

<h4 style="font-size: 20px; margin-bottom: -20px"> Returns </h4>
<div markdown="1">
<div class="md-typeset__scrollwrap"><div class="md-typeset__table">
<table>
<tbody>
<tr>
<td class="apiReferenceMethodBox">void</td>
</tr>
<tr>
</tbody>
</table>
</div>
</div>

### destructor
<a style="color: lightskyblue;">void</a>
<div class="apiReferenceAccessBox" style="background-color: rgb(113, 25, 66); float: none">Internal</div>

The `destructor` function inside the `object`, if it has been set in the `classData` table. This function accepts no parameters and is internal, so it can only be called when `object:Destroy()` is called, and can only be called once. 

<h4 style="font-size: 20px; margin-bottom: -20px"> Returns </h4>
<div markdown="1">
<div class="md-typeset__scrollwrap"><div class="md-typeset__table">
<table>
<tbody>
<tr>
<td class="apiReferenceMethodBox">void</td>
</tr>
<tr>
</tbody>
</table>
</div>
</div>

### Destroy
<a style="color: lightskyblue;">void</a>

This method first calls the `object`'s `destructor` function, then after the `destructor` runs, it goes through the `objectData` table, if a key or value is found to be an `Instance`, it calls `:Destroy()` on that `Instance`, and sets it to `nil`. If not, then it simply sets the key and value to `nil`, and when the `objectData` table is finally empty, it sets the `__locked` property to `true`, preventing further access to any member, function or operator function. 

!!! warning
    At this stage, your `object` should be treated as empty and completely gone. Make sure to remove all references to the `object`, so the garbage collector can pick it up.

<h4 style="font-size: 20px; margin-bottom: -20px"> Returns </h4>
<div markdown="1">
<div class="md-typeset__scrollwrap"><div class="md-typeset__table">
<table>
<tbody>
<tr>
<td class="apiReferenceMethodBox">void</td>
</tr>
<tr>
</tbody>
</table>
</div>
</div>

