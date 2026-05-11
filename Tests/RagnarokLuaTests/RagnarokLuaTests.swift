//
//  RagnarokLuaTests.swift
//  RagnarokLuaTests
//
//  Created by Leon Li on 2023/12/29.
//

import Testing
@testable import RagnarokLua

// lua -> lub
// Windows: luac5.1.exe -o test.lub test.lua
// macOS: wine luac5.1.exe -o test.lub test.lua

// lub -> lua
// Windows: luadec5.1.exe test.lub > test.lua
// macOS: wine luadec5.1.exe test.lub > test.lua

struct RagnarokLuaTests {
    @Test
    func luaDecompiler() throws {
        let url = try #require(Bundle.module.url(forResource: "test", withExtension: "lub"))
        let data = try Data(contentsOf: url)

        let decompiler = LuaDecompiler()
        let decompiledData = try decompiler.decompileData(data)

        let decompiledString = try #require(String(data: decompiledData, encoding: .utf8))
        print(decompiledString)
        #expect(decompiledString.contains("globalVar"))
    }

    @Test
    func luaDecompilerIncompatibleVersion() throws {
        let data = Data([0x1b, 0x4c, 0x75, 0x61, 0x52])
        let decompiler = LuaDecompiler()

        do {
            _ = try decompiler.decompileData(data)
            Issue.record("Expected incompatible version error")
        } catch {
            let nsError = error as NSError
            #expect(nsError.domain == LuaDecompilerErrorDomain)
            #expect(nsError.code == LuaDecompilerError.incompatibleVersion.rawValue)
        }
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

    @Test
    func itemDescription() throws {
        let iteminfoURL = try #require(Bundle.module.url(forResource: "iteminfo", withExtension: "lub"))
        let iteminfo = try Data(contentsOf: iteminfoURL)

        let context = LuaContext()
        try context.load(iteminfo)
        try context.parse("""
        function itemDescription(itemID)
            return tbl[itemID]["identifiedDescriptionName"]
        end
        """)

        let redPortion = try context.call("itemDescription", with: [501]) as? [String]
        let unwrappedRedPortion = try #require(redPortion)
        #expect(unwrappedRedPortion.count == 3)
    }

    @Test
    func skillDescription() throws {
        let jobinheritlistURL = try #require(Bundle.module.url(forResource: "jobinheritlist", withExtension: "lub"))
        let jobinheritlist = try Data(contentsOf: jobinheritlistURL)

        let skillidURL = try #require(Bundle.module.url(forResource: "skillid", withExtension: "lub"))
        let skillid = try Data(contentsOf: skillidURL)

        let skillinfolistURL = try #require(Bundle.module.url(forResource: "skillinfolist", withExtension: "lub"))
        let skillinfolist = try Data(contentsOf: skillinfolistURL)

        let skilldescriptURL = try #require(Bundle.module.url(forResource: "skilldescript", withExtension: "lub"))
        let skilldescript = try Data(contentsOf: skilldescriptURL)

        let context = LuaContext()
        try context.load(jobinheritlist)
        try context.load(skillid)
        try context.load(skillinfolist)
        try context.load(skilldescript)
        try context.parse("""
        function skillDescription(skillID)
            return SKILL_DESCRIPT[skillID]
        end
        """)

        let basicSkill = try context.call("skillDescription", with: [1]) as? [String]
        let unwrappedBasicSkill = try #require(basicSkill)
        #expect(unwrappedBasicSkill.count == 23)
    }

    @Test
    func accessoryName() throws {
        let accessoryidURL = try #require(Bundle.module.url(forResource: "accessoryid", withExtension: "lub"))
        let accessoryid = try Data(contentsOf: accessoryidURL)

        let accnameURL = try #require(Bundle.module.url(forResource: "accname", withExtension: "lub"))
        let accname = try Data(contentsOf: accnameURL)

        let context = LuaContext()
        try context.load(accessoryid)
        try context.load(accname)
        try context.parse("""
        function accessoryName(accessoryID)
            return AccNameTable[accessoryID]
        end
        """)

        let nameOfGoggles = try context.call("accessoryName", with: [1]) as? String
        let unwrappedNameOfGoggles = try #require(nameOfGoggles)
        let convertedNameOfGoggles = unwrappedNameOfGoggles.data(using: .isoLatin1)?.string(using: .korean)
        #expect(convertedNameOfGoggles == "_고글")
    }
}

extension String.Encoding {
    static let korean = String.Encoding(codepage: 949)

    init(codepage: UInt32) {
        let cfStringEncoding = CFStringConvertWindowsCodepageToEncoding(codepage)
        let nsStringEncoding = CFStringConvertEncodingToNSStringEncoding(cfStringEncoding)
        self.init(rawValue: nsStringEncoding)
    }
}

extension Data {
    func string(using encoding: String.Encoding) -> String? {
        String(data: self, encoding: encoding)
    }
}
