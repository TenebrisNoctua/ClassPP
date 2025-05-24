<h1 class="api-header" markdown>
    <span class="api-icon" markdown>:octicons-workflow-24:</span>
    <span class="api-title">final</span>
    <span class="api-type">:</span><a href="../../../dataTypes/class" class="api-type">class</a>
</h1>

```lua
function classpp.final(classTable: {class}): class
```

Marks the given [`class`](../../dataTypes/class.md) or [`class`](../../dataTypes/class.md)es as final. If given multiple, then the first class will be returned.

## Default Syntax

```lua
local Car = final { class "Car" {
	Public = {
        ...
	},
    ...
}}
```

## Without Syntax Sugar

```lua
local Car = final({class("Car")({
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
                    <td>The desired <code>class</code> or <code>class</code>es to be set to final.</td>
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