#include <cthread.h>
#include <lauxlib.h>
#include <lua.h>
#include <lualib.h>
#include <queue.h>
#include <stdlib.h>
#include <unistd.h>

#pragma mark - Private Definitions

typedef struct LuaThreadState {
    lua_State *L;
    const char *code;
    int nargs;
    Queue args;
} LuaThreadState;

typedef enum LuaType {
    LuaTypeNil,
    LuaTypeNumber,
    LuaTypeBoolean,
    LuaTypeString,
    LuaTypeUserData,
    LuaTypeFunction,
} LuaType;

typedef struct LuaValue {
    LuaType type;

    union {
        double number;
        bool boolean;
        const char *string;
        lua_CFunction function;
        void *userData;
    };
} LuaValue;

LuaValue *getLuaValue(lua_State *L, int index)
{
    LuaValue *value = malloc(sizeof(LuaValue));

    switch (lua_type(L, index)) {
        case LUA_TNIL:
            value->type = LuaTypeNil;
            break;
        case LUA_TNUMBER:
            value->type = LuaTypeNumber;
            value->number = lua_tonumber(L, index);
            break;
        case LUA_TBOOLEAN:
            value->type = LuaTypeBoolean;
            value->boolean = lua_toboolean(L, index);
            break;
        case LUA_TSTRING:
            value->type = LuaTypeString;
            value->string = lua_tostring(L, index);
            break;
        case LUA_TLIGHTUSERDATA:
        case LUA_TUSERDATA:
            value->type = LuaTypeUserData;
            value->userData = lua_touserdata(L, index);
            break;
        case LUA_TFUNCTION:
            value->type = LuaTypeFunction;
            value->function = lua_tocfunction(L, index);
            break;
    }

    return value;
}

void pushLuaValue(lua_State *L, LuaValue *value)
{
    switch (value->type) {
        case LuaTypeNil:
            lua_pushnil(L);
            break;
        case LuaTypeNumber:
            lua_pushnumber(L, value->number);
            break;
        case LuaTypeBoolean:
            lua_pushboolean(L, value->boolean);
            break;
        case LuaTypeString:
            lua_pushstring(L, value->string);
            break;
        case LuaTypeUserData:
            lua_pushlightuserdata(L, value->userData);
            break;
        case LuaTypeFunction:
            lua_pushcfunction(L, value->function);
            break;
    }
}

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
        if (luaL_loadfile(state->L, state->code)) {
            printf("Can not load file: %s\n", lua_tostring(state->L, -1));
        }
    } else {
        // TODO: Refactor messages
        if (luaL_loadstring(state->L, state->code)) {
            printf("Can not load code: %s\n", lua_tostring(state->L, -1));
        }
    }

    if (state->nargs > 0) {
        for (int i = 0; i < state->nargs; i++) {
            LuaValue *value = (LuaValue *)pop(&state->args);
            pushLuaValue(state->L, value);
        }
    }

    // TODO: Refactor messages
    if (lua_pcall(state->L, state->nargs, 0, 0)) {
        printf("Can not run code: %s\n", lua_tostring(state->L, -1));
    }

    lua_close(state->L);
}

CThread *getThreadState(lua_State *L, int index)
{
    lua_getfield(L, index, "threadData");
    CThread *threadData = (CThread *)lua_touserdata(L, index + 1);

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
    threadState->nargs = 0;

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
    int nargs = lua_gettop(L);
    Queue *args = initQueue();

    for (int i = 1; i < nargs; i++) {
        int stackIndex = i - nargs;
        LuaValue *value = getLuaValue(L, stackIndex);
        push(args, value);
    }

    CThread *threadData = getThreadState(L, 0 - nargs);
    LuaThreadState *state = (LuaThreadState *)getArgs(*threadData);
    state->args = *args;
    state->nargs = nargs - 1;
    CThreadStatus status = startThread(threadData);

    // TODO: Update handling or remove
    switch (status) {
        case CThreadStatusOk:
            printf("OK\n");
            break;
        case CThreadStatusErrorRestart:
            printf("ERROR RESTART\n");
            break;
        case CThreadStatusError:
            printf("ERROR\n");
            break;
    }

    return 0;
}

static int waitLuaThread(lua_State *L)
{
    CThread *threadData = getThreadState(L, 1);
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

int luaopen_cluautils_thread(lua_State *L)
{
    lua_createtable(L, 0, 1);

    registerFields(L);

    return 1;
}
