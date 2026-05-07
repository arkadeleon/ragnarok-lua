// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ragnarok-lua",
    products: [
        .library(
            name: "RagnarokLua",
            targets: ["RagnarokLua"]
        ),
    ],
    targets: [
        .target(
            name: "RagnarokLua",
            cSettings: [
                .headerSearchPath("lua"),
                .headerSearchPath("luacompact53"),
                .headerSearchPath("luadec"),
            ]
        ),
        .testTarget(
            name: "RagnarokLuaTests",
            dependencies: ["RagnarokLua"],
            resources: [
                .copy("Resources/accessoryid.lub"),
                .copy("Resources/accname.lub"),
                .copy("Resources/iteminfo.lub"),
                .copy("Resources/jobinheritlist.lub"),
                .copy("Resources/skilldescript.lub"),
                .copy("Resources/skillid.lub"),
                .copy("Resources/skillinfolist.lub"),
                .copy("Resources/test.lua"),
                .copy("Resources/test.lub"),
            ]
        ),
    ]
)
