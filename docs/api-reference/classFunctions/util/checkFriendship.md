<h1 class="api-header" markdown>
    <span class="api-icon" markdown>:octicons-workflow-24:</span>
    <span class="api-title">checkFriendship</span>
    <span class="api-type">:</span><a href="https://create.roblox.com/docs/luau/booleans" class="api-type">boolean</a>
</h1>

```lua
function Util.checkFriendship(class: class, methodName: string, method: () -> (), classes: {[string]: class}): boolean
```

This function checks if the given `method` and it's `methodName` is in the given `class`'s `Friend` access specifier.

## Default syntax
```lua
local isAFriend = ClassPP.Util.checkFriendship(class, methodName, method, classes)
```

## Parameters
<span markdown>
    <div class="md-typeset__table">
        <table>
            <tbody>
                <tr>
                    <td class="api-param-highlight">class: <a href="../../../dataTypes/class">class</a></td>
                    <td>The <code>class</code> that the check will be made from.</td>
                </tr>
                <tr>
                    <td class="api-param-highlight">methodName: <a href="https://create.roblox.com/docs/luau/strings">string</a></td>
                    <td>The name of the given <code>method</code>.</td>
                </tr>
                <tr>
                    <td class="api-param-highlight">class: <a href="../../../dataTypes/class">class</a></td>
                    <td>The <code>method</code> that will be checked.</td>
                </tr>
                <tr>
                    <td class="api-param-highlight">classes: <a href="../../../dataTypes/class">{[string]: class}</a></td>
                    <td>A table that contains all of the created <code>class</code>es. Since a <code>class</code> can also be inserted to the <code>Friend</code> access specifier through a <code>string</code> that contains the <code>class</code>'s name, this table is used to find the <code>class</code>es set with this method.</td>
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
                    <td class="api-return-box"><a href="https://create.roblox.com/docs/luau/booleans">boolean</a></td>
                </tr>
            </tbody>
        </table>
    </div>
</div>