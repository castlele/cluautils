#include <lua.h>
#include <lualib.h>
#include <lauxlib.h>
#include <stdio.h>

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
//
// static int newThread(lua_State *L)
// {
//     const char *fileName = luaL_checkstring(L, 1);
//     const char *type = luaL_checkstring(L, 2);
//     Thread *threadObj = (Thread *)lua_newuserdata(L, sizeof(Thread));
//
//     threadObj->type = getThreadType(L, type);
//
//     if (access(fileName, F_OK) == 0) {
//         threadObj->fileName = fileName;
//     } else {
//         threadObj->luaCode = fileName;
//     }
//
//     return 1;
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

static int newThread(lua_State *L)
{
    printf("Created new thread");
    return 0;
}

static const struct luaL_Reg thread[] = {
    {"new", newThread},
    // {"start", startThread},
    // {"wait", waitThread},
    {NULL, NULL},
};

int luaopen_thread(lua_State *L)
{
    luaL_register(L, "thread", thread);
    return 1;
}
