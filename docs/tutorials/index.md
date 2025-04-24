# Getting Started

Welcome to the tutorial section of Class++ !
<br>
Here, you will learn what you need to install Class++, how to install it, and how to create a basic testing script.

## Requirements

To use Class++, you don't need to be an expert developer, all you need is:

* Basic understanding on the concept of OOP (Object Oriented Programming), and Classes.
* Understanding on how [metatables](https://create.roblox.com/docs/luau/metatables) work in Roblox.

Basically, if you're already experienced with OOP, you're good to go!
<br>
Especially, if you already have knowledge in languages like C++ and Java, your job will be pretty easy.

## Installation

Installing Class++ is pretty easy! Just head over to this [link](https://github.com/TenebrisNoctua/ClassPP/releases/latest) to download the `ModuleScript`.

After the download, open Roblox Studio, go into the place that you want to import Class++ to and right click on the `ReplicatedStorage` (or the location that you want to insert into), and select "Insert from File".

Select the `Class++.rbxm` file that you just downloaded, and if the `ModuleScript` has appeared, congratulations, the Installation is complete!

## Creating A Testing Script

Now that you installed Class++, we can create a script to test if it has been successfully installed:

* 1: Create a `Script` or a `LocalScript` instance, and parent it to `workspace` or `StarterPlayer > StarterPlayerScripts`.
* 2: Remove the `print("Hello World")` line, and paste the following code in:

```lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ClassPP = require(ReplicatedStorage["Class++"])
local class = ClassPP.class
```

* 3: Press "Play" or "Run". If everything is working properly and there are no errors, you're good to go!