#include <limits.h>
#include <stdlib.h>
#include <stdio.h>
#include <pthread.h>

#include "cthread.h"

#pragma mark - Private Declarations

typedef struct _CThread {
    void *args;
    Callback callback;
} _CThread;

void *runner(void *args);
_CThread *unwrapPrivate(CThread thread);
pthread_attr_t getAttributes(CThreadParams *params);

#pragma mark - Public Definitions

void *getArgs(CThread thread)
{
    return unwrapPrivate(thread)->args;
}

void setArgs(CThread *thread, void *args)
{
    _CThread *private = unwrapPrivate(*thread);

    private->args = args;
}

CThread *createThreadWithParams(CThreadParams params, Callback callback, void *args)
{
    _CThread private = {
        .args = args,
        .callback = callback,
    };
    CThread *t = malloc(sizeof(CThread));

    // TODO: How to pass id to thread?
    t->id = "hello";
    t->params = params;
    t->private = malloc(sizeof(_CThread));
    *(_CThread *)(t->private) = private;

    return t;
}

CThread *createThread(Callback callback, void *args)
{
    return createThreadWithParams(DEFAULT_PARAMS, callback, args);
}

CThreadStatus startThread(CThread *thread)
{
    _CThread *t = unwrapPrivate(*thread);

    if (t == NULL) {
        return CThreadStatusErrorRestart;
    }

    pthread_attr_t attr = getAttributes(&thread->params);

    int result = pthread_create(&thread->wrappedThread, &attr, runner, t);

    pthread_attr_destroy(&attr);

    if (result != 0) {
        return CThreadStatusError;
    }

    return CThreadStatusOk;
}

void waitThread(CThread *thread)
{
    pthread_join(thread->wrappedThread, NULL);
}

#pragma mark - Private definitions

void *runner(void *args)
{
    _CThread *t = args;

    t->callback(t->args);

    free(t);
    pthread_exit(NULL);
}

_CThread *unwrapPrivate(CThread thread)
{
    return (_CThread *)thread.private;
}

pthread_attr_t getAttributes(CThreadParams *params)
{
    pthread_attr_t attr;

    pthread_attr_init(&attr);

    if (params->isDetached) {
        pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_DETACHED);
    } else {
        pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_JOINABLE);
    }

    return attr;
}
