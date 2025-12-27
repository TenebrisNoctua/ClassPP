<h1 class="api-header" markdown>
    <span class="api-icon" markdown>:octicons-workflow-24:</span>
    <span class="api-title">class</span>
    <span class="api-type">:</span><a href="../../../data-types/class" class="api-type">class</a>
</h1>

```luau
function classpp.class(className: string): (classData: classData) -> class
```

Creates a new [`class`](../../data-types/class.md) with the given [`classData`](../../types/classData.md) table.

## Default Syntax
```luau
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
```luau
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
<span markdown>
    <div class="md-typeset__table">
        <table>
            <tbody>
                <tr>
                    <td class="api-param-highlight">className: <a href="https://create.roblox.com/docs/luau/strings">string</a></td>
                    <td>An unique name for the <code>class</code>.</td>
                </tr>
                <tr>
                    <td class="api-param-highlight">inheritedClasses: <a href="../../../data-types/class">...class</a></td>
                    <td>The <code>class</code>es the created <code>class</code> will inherit from. (Optional)</td>
                </tr>
                <tr>
                    <td class="api-param-highlight">classData: <a href="../../../types/classData">classData</a></td>
                    <td>The <code>classData</code> table that contains the data such as access specifiers for the <code>class</code>.
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
                    <td class="api-return-box"><a href="../../../data-types/class">class</a></td>
                </tr>
            </tbody>
        </table>
    </div>
</div>