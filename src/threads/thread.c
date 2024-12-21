#include <assert.h>
#include <cthread.h>
#include <lauxlib.h>
#include <lua.h>
#include <lualib.h>
#include <queue.h>
#include <stdlib.h>
#include <unistd.h>

#include "lualibutils.h"

#pragma mark - Private Definitions

typedef struct LuaThreadState {
    lua_State *L;
    const char *code;
    int nargs;
    Queue args;
} LuaThreadState;

typedef enum LuaThreadErrorEnv {
    LuaThreadErrorEnvFile,
    LuaThreadErrorEnvString,
    LuaThreadErrorEnvCall,
} LuaThreadErrorEnv;

typedef struct LuaThreadRunningError {
    const char *message;
    LuaThreadErrorEnv env;
} LuaThreadRunningError;

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

    // TODO: Implement loggin system
    switch (lua_type(L, index)) {
        case LUA_TNIL:
            printf("Got nil value\n");
            value->type = LuaTypeNil;
            break;
        case LUA_TNUMBER:
            value->type = LuaTypeNumber;
            value->number = lua_tonumber(L, index);
            printf("Got number value: %f\n", value->number);
            break;
        case LUA_TBOOLEAN:
            value->type = LuaTypeBoolean;
            value->boolean = lua_toboolean(L, index);
            printf("Got boolean value: %s\n", value->boolean ? "true" : "false");
            break;
        case LUA_TSTRING:
            value->type = LuaTypeString;
            value->string = lua_tostring(L, index);
            printf("Got string value: %s\n", value->string);
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

int throwRestartError(lua_State *L)
{
    lua_pushboolean(L, false);
    lua_pushstring(L, "Thread was started again! This is not allowed. One instance of the thread can be started only once!");
    return 2;
}

int throwInternalError(lua_State *L)
{
    lua_pushboolean(L, false);
    lua_pushstring(L, "Internal error occured! Pthread can't be started properly!");
    return 2;
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

void *runThread(void *args)
{
    // WARN: Is this object should be dealloceted here? Or in wait method?
    LuaThreadState *state = (LuaThreadState *)args;
    assert(state);

    LuaThreadRunningError *result = malloc(sizeof(LuaThreadRunningError));

    luaL_openlibs(state->L);

    if (access(state->code, F_OK) == 0) {
        if (luaL_loadfile(state->L, state->code)) {
            result->message = lua_tostring(state->L, -1);
            result->env = LuaThreadErrorEnvFile;
            return result;
        }
    } else {
        if (luaL_loadstring(state->L, state->code)) {
            result->message = lua_tostring(state->L, -1);
            result->env = LuaThreadErrorEnvString;
            return result;
        }
    }

    if (state->nargs > 0) {
        for (int i = 0; i < state->nargs; i++) {
            LuaValue *value = (LuaValue *)pop(&state->args);
            pushLuaValue(state->L, value);
        }
    }

    if (lua_pcall(state->L, state->nargs, 0, 0)) {
        result->message = lua_tostring(state->L, -1);
        result->env = LuaThreadErrorEnvCall;
        return result;
    }

    lua_close(state->L);

    return NULL;
}

CThread *getThreadState(lua_State *L, int index)
{
    // TODO: Constants
    lua_getfield(L, index, "threadData");
    CThread *threadData = (CThread *)lua_touserdata(L, lua_gettop(L));

    assert(threadData);

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

    CThread *threadData = createThread(runThread, threadState);

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
    assert(threadData);

    if (threadData->isRunning) {
        return throwRestartError(L);
    }

    LuaThreadState *state = (LuaThreadState *)getArgs(*threadData);

    if (state != NULL) {
        state->args = *args;
        state->nargs = nargs - 1;
    }

    CThreadStatus status = startThread(threadData);

    switch (status) {
        case CThreadStatusOk:
            break;
        case CThreadStatusErrorRestart:
            return throwRestartError(L);
        case CThreadStatusError:
            return throwInternalError(L);
    }

    lua_pushboolean(L, true);
    return 1;
}

static int waitLuaThread(lua_State *L)
{
    CThread *threadData = getThreadState(L, 1);

    assert(threadData);

    LuaThreadRunningError *result = waitThread(threadData);

    free(threadData);

    // `runThread` method return result only if there is an error occured
    if (result != NULL) {
        // TODO: Add environment information
        lua_pushboolean(L, false);
        lua_pushstring(L, result->message);

        free(result);

        return 2;
    }

    lua_pushboolean(L, true);
    return 1;
}

#pragma mark - Registration

static const struct luaL_Reg thread[] = {
    {"create", createLuaThread},
    {"start", startLuaThread},
    {"wait", waitLuaThread},
    {NULL, NULL},
};

int luaopen_cluautils_thread(lua_State *L)
{
    lua_createtable(L, 0, 1);

    registerFields(L, thread);

    return 1;
}
