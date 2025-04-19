#
<span class="apiReferenceFunctionTitle">checkFriendship</span> <span class="apiReferenceFunctionTypeIndicator">:</span> <a href="https://create.roblox.com/docs/luau/booleans" class="apiReferenceFunctionType" style="color: lightskyblue;">boolean</a>

```lua
function Util.checkFriendship(class: class, methodName: string, method: () -> (), classes: {[string]: class}): boolean
```

This function checks if the given `method` and it's `methodName` is in the given `class`'s `Friend` access specifier.

## Default syntax
```lua
local isAFriend = ClassPP.Util.checkFriendship(class, methodName, method, classes)
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
<td style="background-color: rgb(37, 39, 45); color: #fff">methodName: <a href="https://create.roblox.com/docs/luau/strings" style="color: lightskyblue;">string</a></td>
<td style="width: 74%">The name of the given <code>method</code>.</td>
</tr>
<tr>
<td style="background-color: rgb(37, 39, 45); color: #fff">method: <a style="color: lightskyblue;">() -> ()</a></td>
<td style="width: 74%">The <code>method</code>.</td>
</tr>
<tr>
<td style="background-color: rgb(37, 39, 45); color: #fff">classes: <a href="https://create.roblox.com/docs/luau/tables" style="color: lightskyblue;">Table</a></td>
<td style="width: 74%">A table that contains classes. Since a <code>class</code> can also be inserted to the <code>Friend</code> access specifier through a <code>string</code> that contains the <code>class</code>'s name, this table is used to find the classes set with this method.</td>
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