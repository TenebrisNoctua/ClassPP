<h1 class="api-header" markdown>
    <span class="api-icon" markdown>:octicons-note-24:</span>
    <span class="api-title">autoObjectDestruction</span>
    <span class="api-type">:</span><a href="https://create.roblox.com/docs/luau/booleans" class="api-type">boolean</a>
</h1>

This property indicates whether or not a created [`object`](../data-types/object.md) will automatically be destroyed when its reference has been garbage collected. It is set to `true` by default, and allows Class++ to automatically call the `destructor` function (if defined) of an `object` automatically.

It can be set to `false` if desired, however, you will have to manually destroy every `object` if you do, to prevent memory leaks.