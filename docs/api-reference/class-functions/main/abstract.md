<h1 class="api-header" markdown>
    <span class="api-icon" markdown>:octicons-workflow-24:</span>
    <span class="api-title">abstract</span>
    <span class="api-type">:</span><a href="../../data-types/class.md" class="api-type">class</a>
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
<span markdown>
    <div class="md-typeset__table">
        <table>
            <tbody>
                <tr>
                    <td class="api-param-highlight">classTable: <a href="../../../dataTypes/class">{class}</a></td>
                    <td>The desired <code>class</code> or <code>class</code>es to be set to abstract.</td>
                </tr>
            </tbody>
        </table>
    </div>
</span>

## Returns
<span markdown>
    <div class="md-typeset__table">
        <table>
            <tbody>
                <tr>
                    <td class="api-return-box"><a href="../../../dataTypes/class">class</a></td>
                </tr>
            </tbody>
        </table>
    </div>
</div>