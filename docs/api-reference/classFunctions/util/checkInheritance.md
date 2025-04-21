#
<span class="api-header">
    <span class="api-icon" markdown>:octicons-workflow-24:</span>
    <span class="api-title">checkInheritance</span>
    <span class="api-type">:</span><a href="https://create.roblox.com/docs/luau/booleans" class="api-type">boolean</a>
</span>

```lua
function Util.checkInheritance(class: class, classOrMethod: class | () -> ()): boolean
```

If the `classOrMethod` is a `class`, the function checks if the given `class` has been inherited from `classOrMethod`, or if the `classOrMethod` is a method, then it simply checks if any of the classes that the given `class` inherits from contains the method.

## Default syntax
```lua
local isInherited = ClassPP.Util.checkInheritance(classOne, classTwo) -- For classes
local isInherited = ClassPP.Util.checkInheritance(class, method) -- For methods
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
<td style="background-color: rgb(37, 39, 45); color: #fff">classOrMethod: <a style="color: lightskyblue;">class | () -> ()</a></td>
<td style="width: 74%">The second <code>class</code> or the method.</td>
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