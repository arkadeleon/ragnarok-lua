// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ragnarok-lua",
    products: [
        .library(
            name: "RagnarokLua",
            targets: ["RagnarokLua"]),
    ],
    targets: [
        .target(
            name: "RagnarokLua",
            cSettings: [
                .headerSearchPath("lua"),
                .headerSearchPath("luacompact53"),
                .headerSearchPath("luadec"),
            ]),
        .testTarget(
            name: "RagnarokLuaTests",
            dependencies: ["RagnarokLua"],
            resources: [
                .copy("Resources/test.lua"),
                .copy("Resources/test.lub"),
            ]),
    ]
)
