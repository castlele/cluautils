#include <lua.h>
#include <lualib.h>
#include <lauxlib.h>
#include <unistd.h>
#include <cthread.h>
#include <stdlib.h>

#pragma mark - Private Definitions

typedef struct LuaThreadState {
    lua_State *L;
    const char *code;
} LuaThreadState;

void runCode(void *args)
{
    LuaThreadState *state = (LuaThreadState *)args;

    if (state == NULL) {
        // TODO: Throw error!
        return;
    }

    luaL_openlibs(state->L);

    if (access(state->code, F_OK) == 0) {
        // TODO: Refactor messages
        if (luaL_dofile(state->L, state->code)) {
            printf("Can not run file: %s\n", lua_tostring(state->L, -1));
        } else {
            printf("File done\n");
        }
    } else {
        // TODO: Refactor messages
        if (luaL_loadstring(state->L, state->code) || lua_pcall(state->L, 0, 0, 0)) {
            printf("Can not run code: %s\n", lua_tostring(state->L, -1));
        } else {
            printf("Code done\n");
        }
    }
}

CThread *getThreadState(lua_State *L)
{
    lua_getfield(L, 1, "threadData");
    CThread *threadData = (CThread *)lua_touserdata(L, 2);

    if (threadData == NULL) {
        // TODO: Add proper exception handling
        printf("Can't find threaddata in start method\n");
    }

    return threadData;
}

#pragma mark - Exporting functions

static int createLuaThread(lua_State *L)
{
    const char *code = luaL_checkstring(L, 1);
    LuaThreadState *threadState = malloc(sizeof(LuaThreadState));
    threadState->L = luaL_newstate();
    threadState->code = code;

    CThread *threadData = createThread(runCode, threadState);

    lua_createtable(L, 0, 1);

    // TODO: Constants
    lua_pushstring(L, "threadData");
    lua_pushlightuserdata(L, threadData);
    lua_settable(L, -3);

    return 1;
}

static int startLuaThread(lua_State *L)
{
    CThread *threadData = getThreadState(L);
    // CThreadStatus status = startThread(threadData);

    if (luaL_loadstring(L, "return require(\"cluautils.datastructures.linkedlist\")()") || lua_pcall(L, 0, 1, 0)) {
        printf("Can not get linked list lib: %s\n", lua_tostring(L, -1));
    } else {
        
    }
// require("cluautils.datastructures.linkedlist")
//     for (int i = 0; i < nargs; ++i) {
//         int ud = lua_tointeger(L, i + 2);
//         add(&args, ud);
//     }

    // TODO: Update handling or remove
    // switch (status) {
    //     case CThreadStatusOk:
    //         printf("OK\n");
    //         break;
    //     case CThreadStatusErrorRestart:
    //         printf("ERROR RESTART\n");
    //         break;
    //     case CThreadStatusError:
    //         printf("ERROR\n");
    //         break;
    // }

    return 0;
}

static int waitLuaThread(lua_State *L)
{
    CThread *threadData = getThreadState(L);
    waitThread(threadData);
    return 0;
}

#pragma mark - Registration

static const struct luaL_Reg thread[] = {
    {"create", createLuaThread},
    {"start", startLuaThread},
    {"wait", waitLuaThread},
    {NULL, NULL},
};

void registerFields(lua_State *L)
{
    int index = 0;
    luaL_Reg reg;

    while ((reg = thread[index]).name != NULL) {
        lua_pushstring(L, reg.name);
        lua_pushcfunction(L, reg.func);
        lua_settable(L, -3);
        index++;
    }
}

int luaopen_thread(lua_State *L)
{
    lua_createtable(L, 0, 1);

    registerFields(L);

    return 1;
}
