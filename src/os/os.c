#include <lauxlib.h>
#include <lua.h>
#include <lualib.h>
#include <string.h>

#include "lualibutils.h"

char *getOsName()
{
#ifdef _WIN32
    return "Windows";
#elif _WIN64
    return "Windows";
#elif __APPLE__ || __MACH__
    return "MacOS";
#elif __linux__
    return "Linux";
#elif __FreeBSD__
    return "FreeBSD";
#elif __unix || __unix__
    return "Unix";
#else
    return "Other";
#endif
}

static int luaGetOsName(lua_State *L)
{
    lua_pushstring(L, getOsName());

    return 1;
}

static const struct luaL_Reg luaOS[] = {
    {"getName", luaGetOsName},
    {NULL, NULL},
};

int luaopen_cluautils_os(lua_State *L)
{
    lua_createtable(L, 0, 1);
    registerFields(L, luaOS);

    return 1;
}

