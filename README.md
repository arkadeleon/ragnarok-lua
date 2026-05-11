# Ragnarok Lua

`RagnarokLua` is a Swift package for working with Lua files used by Ragnarok Online.

It can:

- run plain Lua scripts
- load compiled `.lub` files
- read values and call functions from Swift
- decompile Lua 5.1 bytecode back to Lua source

This package is useful if you want to inspect or use Ragnarok client data files in an Apple platform project.

## Features

- Swift Package Manager support
- `LuaContext` for loading and running Lua code
- `LuaDecompiler` for decompiling Lua 5.1 bytecode
- Tested with real Ragnarok `.lub` files such as item, skill, and accessory data

## Requirements

- Swift 6
- Apple platforms with Foundation support

## Installation

Add the package to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/arkadeleon/ragnarok-lua.git", branch: "master")
]
```

Then add `RagnarokLua` to your target dependencies.

There is no tagged release yet, so the package currently uses the `master` branch.

## Usage

Import the package:

```swift
import RagnarokLua
```

### Run a Lua script

```swift
let context = LuaContext()

try context.parse("""
globalVar = {0, 1}

function myFunction(value)
    return value >= globalVar[1]
end
""")

let values = context["globalVar"] as? [Double]
let result = try context.call("myFunction", with: [0.5]) as? Bool
```

### Load a `.lub` file

```swift
let data = try Data(contentsOf: url)

let context = LuaContext()
try context.load(data)
```

You can load more than one Lua or `.lub` file into the same context.

### Decompile a `.lub` file

```swift
let data = try Data(contentsOf: url)

let decompiler = LuaDecompiler()
let sourceData = try decompiler.decompileData(data)
let source = String(data: sourceData, encoding: .utf8)
```

`LuaDecompiler` only supports Lua 5.1 bytecode.

## Testing

Run the test suite with:

```bash
swift test
```

## License

This project is available under the terms of the [LICENSE](LICENSE).
