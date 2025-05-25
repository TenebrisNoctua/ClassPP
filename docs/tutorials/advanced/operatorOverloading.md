# Operator Overloading

Suppose we have two objects that belong to a custom Vector class, how would we allow the addition of those two objects?
Using a normal class function would suffice, but it would require you to call the same function over and over again every single time you want to add them together.

To solve this issue, just like in other OO languages, we can change the way operators work for our classes. This is known as operator overloading.

```lua
local class = ClassPP.class

local Vector = class "Vector3" {
	constructor = function(self, x: number, y: number, z: number)
		if typeof(x) ~= "number" or typeof(y) ~= "number" or typeof(z) ~= "number" then self.coordinates = {0, 0, 0} return end
		self.coordinates = {x, y, z}
	end,
	Public = {
		coordinates = {0, 0, 0},
	},
}

function Vector.Public:operator_add(otherVector)
    assert(#self.coordinates == #otherVector.coordinates)

	local coordinates = {}

	for i = 1, #self.coordinates do
		coordinates[i] = self.coordinates[i] + otherVector.coordinates[i]
	end

	return Vector.new(coordinates[1], coordinates[2], coordinates[3])
end

function Vector.Public:__tostring()
	return "(" .. table.concat(self.coordinates, ", ") .. ")"
end

local vector1 = Vector.new(4, 5, 2)
local vector2 = Vector.new(1, 2, 3)

print(vector1 + vector2) -- Prints "(5, 7, 5)"
```

In this example, we have created a custom Vector3 class that has a special function called `operator_add`, this special function is one of the special functions in Class++ that allows you to overload a specific operator. Here, we overloaded the operator `+` with our custom function that allows us to add two Vectors together.

## Overloadable Operators

<div markdown="1" class="operator_overloading_table">
	<div class="operator_overloading_table">
		<div class="md-typeset__scrollwrap">
			<div class="md-typeset__table">
				<table>
					<thead>
						<tr>
							<th class="operator_overloading_method">Method</th>
							<th class="operator_overloading_description">Description</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td><code>operator_add(self, obj)</code></td>
							<td>Function for overloading the + operator.</td>
						</tr>
						<tr>
							<td><code>operator_sub(self, obj)</code></td>
							<td>Function for overloading the - operator.</td>
						</tr>
						<tr>
							<td><code>operator_mul(self, obj)</code></td>
							<td>Function for overloading the * operator.</td>
						</tr>
						<tr>
							<td><code>operator_div(self, obj)</code></td>
							<td>Function for overloading the / operator.</td>
						</tr>
						<tr>
							<td><code>operator_idiv(self, obj)</code></td>
							<td>Function for overloading the // operator.</td>
						</tr>
						<tr>
							<td><code>operator_mod(self, obj)</code></td>
							<td>Function for overloading the % operator.</td>
						</tr>
						<tr>
							<td><code>operator_pow(self, obj)</code></td>
							<td>Function for overloading the ^ operator.</td>
						</tr>
						<tr>
							<td><code>operator_unm(self)</code></td>
							<td>Function for overloading the unary – operator.</td>
						</tr>
						<tr>
							<td><code>operator_eq(self, obj)</code></td>
							<td>Function for overloading the == operator.¹</td>
						</tr>
						<tr>
							<td><code>__tostring()</code></td>
							<td>Fired when tostring is called on the object.</td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>
	</div>
</div>

!!! info 
    ¹: This function will only run when == operator is used with the same base type (table, userdata, etc.).
    It will not work with different types, such as an object with a table, or another type.

!!! warning
    Trying to directly call the operator functions will result in an error. They must be called with their operators.