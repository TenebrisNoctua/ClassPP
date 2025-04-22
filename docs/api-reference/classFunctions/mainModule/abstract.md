<h1 class="api-header" markdown>
    <span class="api-icon" markdown>:octicons-workflow-24:</span>
    <span class="api-title">abstract</span>
    <span class="api-type">:</span><a href="../../../dataTypes/class" class="api-type">class</a>
</h1>

```lua
function classpp.abstract(classTable: {class}): class
```
Marks the given [`class`](../../dataTypes/class.md) or [`class`](../../dataTypes/class.md)es as abstract. If given multiple, then the first class will be returned.

## Default Syntax

```lua
local Car = abstract { class "Car" {
	Public = {
        ...
	},
    ...
}}
```

## Without Syntax Sugar

```lua
local Car = abstract({class("Car")({
	Public = {
        ...
	},
    ...
})})
```

## Parameters
<div markdown="1">
<div class="md-typeset__scrollwrap"><div class="md-typeset__table">
<table>
<tbody>
<tr>
<td style="background-color: rgb(37, 39, 45); color: #fff">classTable: <a href="../../../dataTypes/class" style="color: lightskyblue;">{class}</a></td>
<td style="width: 82%">The desired <code>class</code> or <code>class</code>es to be set to abstract.</td>
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
