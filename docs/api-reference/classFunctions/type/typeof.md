<h1 class="api-header" markdown>
    <span class="api-icon" markdown>:octicons-workflow-24:</span>
    <span class="api-title">typeof</span>
    <span class="api-type">:</span><a href="https://create.roblox.com/docs/luau/strings" class="api-type">string</a>
</h1>

```lua
function Type.typeof(object: any): string
```

Returns the type of the given `object`. Behaves the same as the built-in Roblox `typeof()` function, but with additional support for `class`es and `object`s.

## Default syntax
```lua
local objectType = ClassPP.Type.typeof(object)
```

## Parameters
<span markdown>
    <div class="md-typeset__table">
        <table>
            <tbody>
                <tr>
                    <td class="api-param-highlight">object: <a href="../../../dataTypes/object">object</a></td>
                    <td style="width: 74%">The <code>object</code>.</td>
                </tr>
            </tbody>
        </table>
    </div>
</span>

<h2 markdown class="api-returns-title"> Returns </h2>

<span markdown>
    <div class="md-typeset__table">
        <table>
            <tbody>
                <tr>
                    <td class="api-return-box"><a href="https://create.roblox.com/docs/luau/strings">string</a></td>
                </tr>
            </tbody>
        </table>
    </div>
</div>