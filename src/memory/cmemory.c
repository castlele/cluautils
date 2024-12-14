#include <lua.h>
#include <lualib.h>
#include <lauxlib.h>
#include <stdio.h>

static int getLuaAddress(lua_State *L)
{
    lua_gettable(L, 1);
    return 0;
}

static const struct luaL_Reg memory[] = {
    {"get", getLuaAddress},
    {NULL, NULL},
};

void registerFields(lua_State *L)
{
    int index = 0;
    luaL_Reg reg;

    while ((reg = memory[index]).name != NULL) {
        lua_pushstring(L, reg.name);
        lua_pushcfunction(L, reg.func);
        lua_settable(L, -3);
        index++;
    }
}

int luaopen_cluautils_memory(lua_State *L)
{
    lua_createtable(L, 0, 1);

    registerFields(L);

    return 1;
}
