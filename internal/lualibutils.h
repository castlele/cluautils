#ifndef __LUA_LIB_UTILS_H_
#define __LUA_LIB_UTILS_H_

#include <lua.h>

void registerFields(lua_State *L, const struct luaL_Reg *regList);

void registerFields(lua_State *L, const struct luaL_Reg *regList)
{
    int index = 0;
    luaL_Reg reg;

    while ((reg = regList[index]).name != NULL) {
        lua_pushstring(L, reg.name);
        lua_pushcfunction(L, reg.func);
        lua_settable(L, -3);
        index++;
    }
}

#endif

