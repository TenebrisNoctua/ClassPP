# Getting Started

Welcome to the Class++ tutorial section! In here, you will learn how to use and build systems with Class++.

## What You Should Know

While you don't need to be an expert programmer to use Class++, you should still have:

* Basic knowledge of Luau.
   * While not a requirement, having basic knowledge of [metatables](https://create.roblox.com/docs/luau/metatables) will definitely benefit you.
* Basic understanding on the concept of OOP (Object Oriented Programming).

Some tutorials may seem harder or easier depending on your existing knowledge. It is recommended that you follow each one in order, and try the given examples on your own.

## Installation

### Installing via Roblox

If you are creating experiences in Roblox, and you wish to install Class++, you can either:

* Download the `.rbxm` file that contains the source code from the [latest release](https://github.com/TenebrisNoctua/ClassPP/releases/latest).
   * 1: Then, in Roblox Studio, right click the location (e.g, `ReplicatedStorage`) that you wish to insert this file to.
   * 2: Go to "Insert > Import Roblox Model".
   * 3: Select the `ClassPP.rbxm` file that you've just downloaded.

* Get the source code from [Roblox Creator Store](https://create.roblox.com/store/asset/18312821151/Class).
   * 1: Then, in Roblox Studio, open Toolbox.
   * 2: Go to "Inventory > Models".
   * 3: Select the "Class++" item on your inventory. It should automatically be inserted into `Workspace`.

### Installing as Source Code

If you're using pure Luau, or if you're just synchronising external files into Roblox Studio, then you can use the source code instead.<br>
To do this, you can either:

* From the [latest release](https://github.com/TenebrisNoctua/ClassPP/releases/latest), download the source code as zip.
   * 1: Inside the zip, copy the `src` folder.
   * 2: Paste this folder into wherever you please, for example, inside another folder named `lib` or `shared`.
   * 3: Rename this pasted `src` folder as "ClassPP".

* From the [wally package manager](https://wally.run/package/tenebrisnoctua/classpp).
   * 1: Copy the code on the "Install" section.
   * 2: Inside your `wally.toml` file, paste this code under the "dependencies" section.
   * 3: Run `wally install` through the command line.

## Testing

To make sure if Class++ has been successfully installed or not, you can create a simple script to test.

### Testing from Roblox

* 1: Create a `Script` or a `LocalScript` instance, and parent it to `workspace` or `StarterPlayer > StarterPlayerScripts`.
* 2: Remove the `print("Hello World")` line, and paste the following code in:

```luau
local ReplicatedStorage = game:GetService("ReplicatedStorage") -- If you've inserted it to somewhere else, you can change this line.
local ClassPP = require(ReplicatedStorage.ClassPP)
local class = ClassPP.class
```

* 3: Press "Play" or "Run". If everything is working properly and there are no errors, you're good to go!

### Testing from Source Code

If you're using the source code, you can `require()` Class++ in one of the following ways:

```luau
-- Rojo (Roblox Instance)
local ClassPP = require(ReplicatedStorage.ClassPP)

-- Vanilla Luau (Using Require By String)
local ClassPP = require("../shared/ClassPP")
```