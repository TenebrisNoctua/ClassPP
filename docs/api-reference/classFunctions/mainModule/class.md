#
<span class="api-header">
    <span class="api-icon" markdown>:octicons-workflow-24:</span>
    <span class="api-title">class</span>
    <span class="api-type">:</span><a href="../../../dataTypes/class" class="api-type">class</a>
</span>

```lua
function classpp.class(className: string): (classData: classData) -> class
```

Creates a new [`class`](../../dataTypes/class.md) with the given [`classData`](../../types/classData.md) table.

## Default Syntax
```lua
local Class = class "Class" {
    constructor = function(self)
        ...
    end,
    destructor = function(self)
        ...
    end,
	Public = {
        ...
	},
    Private = {
        ...
    },
    Protected = {
        ...
    },
    Friend = {
        ...
    }
}
```

## Without Syntax Sugar
```lua
local Class = class("Class")({
    constructor = function(self)
        ...
    end,
    destructor = function(self)
        ...
    end,
	Public = {
        ...
	},
    Private = {
        ...
    },
    Protected = {
        ...
    },
    Friend = {
        ...
    }
})
```

## Parameters
<div markdown="1">
<div class="md-typeset__scrollwrap"><div class="md-typeset__table">
<table>
<tbody>
<tr>
<td style="background-color: rgb(37, 39, 45); color: #fff">className: <a href="https://create.roblox.com/docs/luau/strings" style="color: lightskyblue;">string</a></td>
<td style="width: 74%">The class name for the new <code>class</code>.</td>
</tr>
<tr>
<td style="background-color: rgb(37, 39, 45); color: #fff">classData: <a href="https://create.roblox.com/docs/luau/tables" style="color: lightskyblue;">Table</a></td>
<td style="width: 74%">The <code>classData</code> value that contains the data about the new class.</td>
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