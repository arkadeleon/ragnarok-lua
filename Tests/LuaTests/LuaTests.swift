//
//  LuaTests.swift
//  LuaTests
//
//  Created by Leon Li on 2023/12/29.
//

import Testing
@testable import Lua

// luac5.1.exe -o test.lub test.lua

struct LuaTests {
    @Test
    func luaDecompiler() throws {
        let url = try #require(Bundle.module.url(forResource: "test", withExtension: "lub"))
        let data = try Data(contentsOf: url)

        let decompiler = LuaDecompiler()
        let decompiledData = try #require(decompiler.decompileData(data))

        let decompiledString = try #require(String(data: decompiledData, encoding: .utf8))
        #expect(decompiledString.contains("globalVar"))
    }

    @Test
    func luaContext() throws {
        let url = try #require(Bundle.module.url(forResource: "test", withExtension: "lua"))
        let string = try String(contentsOf: url, encoding: .utf8)

        let context = LuaContext()
        try context.parse(string)

        let globalVar = try #require(context["globalVar"] as? [Double])
        #expect(globalVar == [0.0, 1.0])

        let initialResult = try context.call("myFunction", with: [0.5]) as? Bool
        let unwrappedInitialResult = try #require(initialResult as Bool?)
        #expect(unwrappedInitialResult == true)

        context.setObject([0.2, 0.4], forKeyedSubscript: "globalVar" as NSString)
        let updatedResult = try context.call("myFunction", with: [0.5]) as? Bool
        let unwrappedUpdatedResult = try #require(updatedResult as Bool?)
        #expect(unwrappedUpdatedResult == false)
    }

    @Test
    func lubContext() throws {
        let url = try #require(Bundle.module.url(forResource: "test", withExtension: "lub"))
        let data = try Data(contentsOf: url)

        let context = LuaContext()
        try context.load(data)

        let globalVar = try #require(context["globalVar"] as? [Double])
        #expect(globalVar == [0.0, 1.0])

        let functionResult = try context.call("myFunction", with: [0.5]) as? Bool
        let unwrappedFunctionResult = try #require(functionResult as Bool?)
        #expect(unwrappedFunctionResult == true)
    }
}
