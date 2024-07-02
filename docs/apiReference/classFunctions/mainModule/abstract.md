#
<span class="apiReferenceFunctionTitle">abstract</span> <span class="apiReferenceFunctionTypeIndicator">:</span> <a href="../../../dataTypes/class" class="apiReferenceFunctionType" style="color: lightskyblue;">class</a>

```lua
function classpp.abstract(class: class): class
```
Marks the given [`class`](../../dataTypes/class.md) as abstract.

## Default Syntax

```lua
local Car = abstract ( class "Car" {
	Public = {
        ...
	},
    ...
})
```

## Without Syntax Sugar

```lua
local Car = abstract(class("Car")({
	Public = {
        ...
	},
    ...
}))
```

## Parameters
<div markdown="1">
<div class="md-typeset__scrollwrap"><div class="md-typeset__table">
<table>
<tbody>
<tr>
<td style="background-color: rgb(37, 39, 45); color: #fff">class: <a href="../../../dataTypes/class" style="color: lightskyblue;">class</a></td>
<td style="width: 82%">The desired <code>class</code> to be set to abstract.</td>
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
<td class="apiReferenceMethodBox">class</td>
</tr>
<tr>
</tbody>
</table>
</div>
</div>
