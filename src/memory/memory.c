#include <lauxlib.h>
#include <lua.h>
#include <lualib.h>
#include <string.h>

#include "lualibutils.h"

#define MEMORY_ADDR_SIZE 15

static int getLuaAddress(lua_State *L)
{
    const void *ptr = lua_topointer(L, 1);
    char str[MEMORY_ADDR_SIZE];

    snprintf(str, sizeof(char) * MEMORY_ADDR_SIZE, "%p", ptr);
    lua_pushstring(L, str);

    return 1;
}

static const struct luaL_Reg memory[] = {
    {"get", getLuaAddress},
    {NULL, NULL},
};

int luaopen_cluautils_memory(lua_State *L)
{
    lua_createtable(L, 0, 1);
    registerFields(L, memory);

    return 1;
}
