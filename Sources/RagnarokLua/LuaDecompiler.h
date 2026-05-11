//
//  LuaDecompiler.h
//  RagnarokLua
//
//  Created by Leon Li on 2023/12/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSErrorDomain const LuaDecompilerErrorDomain;

typedef NS_ERROR_ENUM(LuaDecompilerErrorDomain, LuaDecompilerError) {
    LuaDecompilerErrorIncompatibleVersion = 1,
};

@interface LuaDecompiler : NSObject

/// Decompiles Lua 5.1 bytecode data.
/// - Parameters:
///   - data: Lua bytecode data to decompile.
///   - error: On return, contains `LuaDecompilerErrorIncompatibleVersion` if the bytecode version is unsupported.
/// - Returns: Decompiled Lua source data, or `nil` if decompilation fails.
- (nullable NSData *)decompileData:(NSData *)data error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
