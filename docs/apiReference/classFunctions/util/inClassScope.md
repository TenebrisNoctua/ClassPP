#
<span class="apiReferenceFunctionTitle">inClassScope</span> <span class="apiReferenceFunctionTypeIndicator">:</span> <a href="https://create.roblox.com/docs/luau/booleans" class="apiReferenceFunctionType" style="color: lightskyblue;">boolean</a>

```lua
function Util.inClassScope(class: class, includeInherited: boolean, includeFriend: boolean, classes: {[string]: class}?, defaultLevel: number?): boolean
```

This function checks if the current thread is allowed to access a specific `class` property from a certain access specifier.

## Default syntax
```lua
local isAllowed = Util.inClassScope(class, false, true, Classes) -- For the Private access specifier
```

## Parameters
<div markdown="1">
<div class="md-typeset__scrollwrap"><div class="md-typeset__table">
<table>
<tbody>
<tr>
<td style="background-color: rgb(37, 39, 45); color: #fff">class: <a href="../../../dataTypes/class" style="color: lightskyblue;">class</a></td>
<td style="width: 74%">The <code>class</code>.</td>
</tr>
<tr>
<td style="background-color: rgb(37, 39, 45); color: #fff">includeInherited: <a href="https://create.roblox.com/docs/luau/booleans" style="color: lightskyblue;">boolean</a></td>
<td style="width: 74%">Determines if inherited classes can access.</td>
</tr>
<tr>
<td style="background-color: rgb(37, 39, 45); color: #fff">includeFriend: <a href="https://create.roblox.com/docs/luau/booleans" style="color: lightskyblue;">boolean</a></td>
<td style="width: 74%">Determines if friend classes/methods can access.</td>
</tr>
<tr>
<td style="background-color: rgb(37, 39, 45); color: #fff">classes: <a href="https://create.roblox.com/docs/luau/tables" style="color: lightskyblue;">Table</a></td>
<td style="width: 74%">A table that contains classes. If <code>includeFriend</code> is set to <code>true</code>, this table will be given to the <code>Util.checkFriendship()</code> function. </td>
</tr>
<tr>
<td style="background-color: rgb(37, 39, 45); color: #fff">defaultLevel: <a href="https://create.roblox.com/docs/luau/numbers" style="color: lightskyblue;">number</a></td>
<td style="width: 74%">Determines the default call stack level the function will start doing the checks on.</td>
</tr>
</tbody>
</table>
</div>
</div>

<h2 markdown="1" style="font-size: 1.5625em; margin-bottom: -20px; margin-top: -30px"> Returns </h2>
<div markdown="1">
<div class="md-typeset__scrollwrap"><div class="md-typeset__table">
<table>
<tbody>
<tr>
<td class="apiReferenceMethodBox">boolean</td>
</tr>
<tr>
</tbody>
</table>
</div>
</div>