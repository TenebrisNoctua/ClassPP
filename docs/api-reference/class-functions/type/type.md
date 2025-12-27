<h1 class="api-header" markdown>
    <span class="api-icon" markdown>:octicons-workflow-24:</span>
    <span class="api-title">type</span>
    <span class="api-type">:</span><a href="https://create.roblox.com/docs/luau/strings" class="api-type">string</a>
</h1>

```luau
function Type.type(object: any): string
```

Returns the true type of the given `object`. Behaves the same as the built-in `type()` function, but with additional support for `class`es and `object`s.

## Default syntax
```luau
local objectType = ClassPP.Type.type(object)
```

## Parameters
<span markdown>
    <div class="md-typeset__table">
        <table>
            <tbody>
                <tr>
                    <td class="api-param-highlight">object: <a href="../../../data-types/object">object</a></td>
                    <td>The <code>object</code>.</td>
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
                    <td class="api-return-box"><a href="https://create.roblox.com/docs/luau/strings">string</a></td>
                </tr>
            </tbody>
        </table>
    </div>
</div>