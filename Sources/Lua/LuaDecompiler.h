//
//  LuaDecompiler.h
//  Lua
//
//  Created by Leon Li on 2023/12/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LuaDecompiler : NSObject

- (nullable NSData *)decompileData:(NSData *)data;

@end

NS_ASSUME_NONNULL_END
