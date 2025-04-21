#
<span class="api-header">
    <span class="api-icon" markdown>:octicons-workflow-24:</span>
    <span class="api-title">type</span>
    <span class="api-type">:</span><a href="https://create.roblox.com/docs/luau/strings" class="api-type">string</a>
</span>

```lua
function Type.type(object: any): string
```

Returns the true type of the given `object`. Behaves the same as the built-in `type()` function, but with additional support for `class`es and `object`s.

## Default syntax
```lua
local objectType = ClassPP.Type.type(object)
```

## Parameters
<div markdown>
    <div class="md-typeset__scrollwrap"><div class="md-typeset__table">
        <table>
            <tbody>
                <tr>
                    <td style="background-color: rgb(37, 39, 45); color: #fff">object: <a href="../../../dataTypes/object"  style="color:        lightskyblue;      ">object</a></td>
                    <td style="width: 74%">The <code>object</code>.</td>
                </tr>
            </tbody>
        </table>
    </div>
</div>

<h2 markdown style="font-size: 1.5625em; margin-bottom: -20px; margin-top: -30px"> Returns </h2>
    <div markdown>
        <div class="md-typeset__scrollwrap"><div class="md-typeset__table">
        <table>
            <tbody>
                <tr>
                    <td class="apiReferenceMethodBox">string</td>
                </tr>
            <tr>
            </tbody>
        </table>
    </div>
</div>