#include <lua.h>
#include <lualib.h>
#include <lauxlib.h>
#include <unistd.h>
#include <cthread.h>

// typedef enum ThreadType {
//     ThreadTypeDetached = 0,
//     ThreadTypeJoinable,
//     ThreadTypeUnknown,
// } ThreadType;
//
// typedef struct Node {
//     int value;
//     struct Node *next;
// } Node;
//
// typedef struct LinkedList {
//     Node *head;
//     int len;
// } LinkedList;
//
// void add(LinkedList *list, int value)
// {
//     if (list == NULL) return;
//
//     Node newNode = { .value = value, .next = NULL };
//
//     if (list->head == NULL) {
//         list->head = &newNode;
//     } else {
//         Node *prevNode = NULL;
//         Node *currentNode = list->head;
//
//         while (currentNode != NULL) {
//             prevNode = currentNode;
//             currentNode = currentNode->next;
//         }
//
//         prevNode->next = &newNode;
//     }
//
//     list->len += 1;
// }
//
// typedef struct Thread {
//     const char *fileName;
//     const char *luaCode;
//     LinkedList args;
//     ThreadType type;
//     lua_State *stack;
//     pthread_t thread;
// } Thread;
//
// static void pushArguments(lua_State *L, LinkedList *args)
// {
//     printf("Adding...\n");
//     printf("LEN: %i\n", args->len);
//     Node currentNode = *args->head;
//     printf("VALUE: %i\n", currentNode.value);
//     lua_pushinteger(L, currentNode.value);
//     // currentNode = currentNode->next;
//
//     // while (currentNode != NULL) {
//     //     printf("Arg: %i\n", (int)currentNode->value);
//     // }
// }
//
// static void *runThread(void *arg)
// {
//     Thread *this = arg;
//
//     this->stack = luaL_newstate();
//     luaL_openlibs(this->stack);
//
//     if (this->fileName != NULL) {
//         if (luaL_dofile(this->stack, this->fileName)) {
//             printf("Can not run file: %s\n", lua_tostring(this->stack, -1));
//         }
//     }
//
//     luaL_loadstring(this->stack, this->luaCode);
//     pushArguments(this->stack, &this->args);
//     // lua_pushlightuserdata(this->stack, this->args);
//
//     if (this->luaCode != NULL) {
//         if (lua_pcall(this->stack, this->args.len, 0, 0)) {
//             printf("Can not run code: %s\n", lua_tostring(this->stack, -1));
//         }
//     }
//
//
//     lua_close(this->stack);
//     pthread_exit(NULL);
// }
//
//
// static int newThread(lua_State *L)
// {
// }
//
// static int startThread(lua_State *L)
// {
//     Thread *thread = (Thread *)lua_touserdata(L, 1);
//     int nargs = lua_gettop(L) - 1;
//     LinkedList args = { .head = NULL, .len = 0 };
//
//     for (int i = 0; i < nargs; ++i) {
//         int ud = lua_tointeger(L, i + 2);
//         add(&args, ud);
//
//     }
//
//     thread->args = args;
//
//     pthread_attr_t attr;
//     pthread_attr_init(&attr);
//
//     switch (thread->type) {
//         case ThreadTypeDetached:
//             pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_DETACHED);
//             break;
//         case ThreadTypeJoinable:
//             pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_JOINABLE);
//             break;
//         case ThreadTypeUnknown:
//             break;
//     }
//
//     int rc = pthread_create(&thread->thread, &attr, runThread, (void *)thread);
//
//     pthread_attr_destroy(&attr);
//
//     return 0;
// }
//
// static int waitThread(lua_State *L)
// {
//     Thread *thread = (Thread *)lua_touserdata(L, 1);
//
//     if (thread->type != ThreadTypeJoinable) {
//         return 0;
//     }
//
//     pthread_join(thread->thread, NULL);
//
//     return 0;
// }
// static ThreadType getThreadType(lua_State *L, const char *stringType)
// {
//
//     if (stringType == NULL) {
//         return ThreadTypeDetached;
//     }
//
//     if (strcmp(stringType, "detached") == 0) {
//         return ThreadTypeDetached;
//     }
//
//     if (strcmp(stringType, "joinable") == 0) {
//         return ThreadTypeJoinable;
//     }
//
//     luaL_error(L, "Unknown thread type passed: %s", stringType);
//
//     return ThreadTypeUnknown;
// }

#pragma mark - Private Definitions

typedef struct LuaThreadState {
    lua_State *L;
    const char *code;
} LuaThreadState;

void runCode(void *args)
{
    printf("Running code\n");
    LuaThreadState state = { .L = luaL_newstate(), .code = "print(\"hello world\")", };
    // LuaThreadState *state = (LuaThreadState *)args;

    // if (state == NULL) {
    //     // TODO: Throw error!
    //     return;
    // }

    luaL_openlibs(state.L);

    if (access(state.code, F_OK) == 0) {
        // TODO: Refactor errors
        if (luaL_dofile(state.L, state.code)) {
            printf("Can not run file: %s\n", lua_tostring(state.L, -1));
        } else {
            printf("File done\n");
        }
    } else {
        if (luaL_loadstring(state.L, state.code) || lua_pcall(state.L, 0, 0, 0)) {
            // TODO: Refactor errors
            printf("Can not run code: %s\n", lua_tostring(state.L, -1));
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
    LuaThreadState threadState = { .L = luaL_newstate(), .code = code, };
    CThread threadData = createThread(runCode, NULL);//, (void *)&threadState);

    printf("created: %s\n", threadData.id);

    // lua_createtable(L, 0, 2);

    // lua_pushstring(L, "threadData");
    lua_pushlightuserdata(L, (void *)&threadData);
    // lua_settable(L, -3);

    return 1;
}

static int startLuaThread(lua_State *L)
{
    // CThread *threadData = getThreadState(L);
    CThread *threadData = lua_touserdata(L, 1);
    CThreadStatus status = startThread(threadData);

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
    // CThread *threadData = getThreadState(L);
    CThread *threadData = lua_touserdata(L, 1);
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
