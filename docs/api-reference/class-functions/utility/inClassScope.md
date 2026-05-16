<h1 class="api-header" markdown>
    <span class="api-icon" markdown>:octicons-workflow-24:</span>
    <span class="api-title">inClassScope</span>
    <span class="api-type">:</span><a href="https://create.roblox.com/docs/luau/booleans" class="api-type">boolean</a>
</h1>

```luau
function Util.inClassScope(class: internalClass, objectData: objectData, overloadedFunctions: {(...any) -> (...any?)}, includeInherited: boolean, includeFriend: boolean, classes: {[string]: internalClass}?, defaultLevel: number?): boolean
```

This function checks if the current thread is allowed to access a specific `class` property from a certain access specifier.

## Default syntax
```luau
local isAllowed = Util.inClassScope(class, objectData, overloadedFunctions, false, true, classes) -- For the Private access specifier
```

## Parameters
<span markdown>
    <div class="md-typeset__table">
        <table>
            <tbody>
                <tr>
                    <td class="api-param-highlight">class: <a href="../../../data-types/class">class</a></td>
                    <td>The <code>class</code> that the check will be made from.</td>
                </tr>
                <tr>
                    <td class="api-param-highlight">objectData: <a href="../../../types/classData">object</a></td>
                    <td>The <code>objectData</code> table that the check will be made with. A <code>classData</code> table can also be used.</td>
                </tr>
                <tr>
                    <td class="api-param-highlight">overloadedFunctions: <a href="https://create.roblox.com/docs/luau/tables">{(...any) -> (...any?)}</a></td>
                    <td>A table that contains overloaded functions. This table is necessary for the overloaded functions of the class to access private members.</td>
                </tr>
                <tr>
                    <td class="api-param-highlight">includeInherited: <a href="https://create.roblox.com/docs/luau/booleans">boolean</a></td>
                    <td>Determines if the inherited <code>class</code>es can access.</td>
                </tr>
                <tr>
                    <td class="api-param-highlight">includeFriend: <a href="https://create.roblox.com/docs/luau/booleans">boolean</a></td>
                    <td>Determines if the friend <code>class</code>es can access.</td>
                </tr>
                <tr>
                    <td class="api-param-highlight">classes: <a href="../../../data-types/class">{[string]: class}</a></td>
                    <td>A table that contains classes. If <code>includeFriend</code> is set to <code>true</code>, this table will be given to the <a href="../checkFriendship">Util.checkFriendship</a> function.</td>
                </tr>
                <tr>
                    <td class="api-param-highlight">defaultLevel: <a href="https://create.roblox.com/docs/luau/numbers">number</a></td>
                    <td>Determines the default call stack level the function will start doing the checks on.</td>
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