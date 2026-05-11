//
//  LuaDecompiler.m
//  RagnarokLua
//
//  Created by Leon Li on 2023/12/29.
//

#import "LuaDecompiler.h"
#include "lua.h"
#include "lualib.h"
#include "lauxlib.h"
#include "lobject.h"
#include "decompile.h"
#include "proto.h"

extern lua_State* glstate;

NSErrorDomain const LuaDecompilerErrorDomain = @"LuaDecompilerErrorDomain";

@interface LuaDecompiler () {
    lua_State *l;
}

@end

@implementation LuaDecompiler

- (instancetype)init {
    self = [super init];
    if (self) {
        InitOperators();
        l = luaL_newstate();
        luaL_openlibs(l);
    }
    return self;
}

- (void)dealloc {
    lua_close(l);
}

- (NSData *)decompileData:(NSData *)data error:(NSError **)error {
    // Only lua 5.1 is supported.
    if (data.length < 5 || ((uint8_t *)data.bytes)[4] != 0x51) {
        if (error) {
            NSDictionary<NSErrorUserInfoKey, id> *userInfo = @{
                NSLocalizedDescriptionKey: @"Only Lua 5.1 bytecode can be decompiled."
            };
            *error = [NSError errorWithDomain:LuaDecompilerErrorDomain
                                         code:LuaDecompilerErrorIncompatibleVersion
                                     userInfo:userInfo];
        }
        return nil;
    }

    glstate = l;

    luaL_loadbuffer(l, data.bytes, data.length, nil);

    Closure *c = (Closure *)lua_topointer(l, -1);
    Proto *f = c->l.p;
    char *code = luaU_decompile(f, 0);

    NSData *decompiledData = [NSData dataWithBytesNoCopy:code length:strlen(code)];
    return decompiledData;
}

@end
