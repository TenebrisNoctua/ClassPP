<h1 class="api-header" markdown>
    <span class="api-icon" markdown>:octicons-note-24:</span>
    <span class="api-title">version</span>
</h1>

```luau
export type version = {
	major: number,
	minor: number,
	patch: number,
	beta: boolean
}
```

Describes a version of Class++ source code.

----

## Properties

<h3 markdown>
	major
	<span class="api-property-type">
		: number
	</span>
</h3>

The major version number. Two versions with different major numbers are expected to be incompatible, and have breaking changes.

----

<h3 markdown>
	minor
	<span class="api-property-type">
		: number
	</span>
</h3>

The minor version number. Two versions with different minor, but not major numbers are expected to be mostly compatible, but may have certain changes.

----

<h3 markdown>
	patch
	<span class="api-property-type">
		: number
	</span>
</h3>

The patch version number. Two versions with different patch, but not major or minor numbers are expected to be highly compatible. The patch version number only increases when bug fixes or very minor changes have been made.

----

<h3 markdown>
	beta
	<span class="api-property-type">
		: boolean
	</span>
</h3>

Describes whether or not the version is beta. If `true`, then the version is seperate from release versions, and may only be available on certain platforms.
