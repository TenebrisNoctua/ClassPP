<h1 class="api-header" markdown>
    <span class="api-icon" markdown>:octicons-workflow-24:</span>
    <span class="api-title">checkInheritance</span>
    <span class="api-type">:</span><a href="https://create.roblox.com/docs/luau/booleans" class="api-type">boolean</a>
</h1>

```lua
function Util.checkInheritance(class: class, classOrMethod: class | () -> ()): boolean
```

If the `classOrMethod` is a `class`, the function checks if the given `class` has been inherited from `classOrMethod`, or if the `classOrMethod` is a method, then it simply checks if any of the classes that the given `class` inherits from contains the method.

## Default syntax
```lua
local isInherited = ClassPP.Util.checkInheritance(classOne, classTwo) -- For classes
local isInherited = ClassPP.Util.checkInheritance(class, method) -- For methods
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
                    <td class="api-param-highlight">classOrMethod: <a href="../../../dataTypes/class">class | () ->()</a></td>
                    <td>The <code>class</code> or the <code>method</code> that will be checked.</td>
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