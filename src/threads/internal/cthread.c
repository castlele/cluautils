#include <stdlib.h>
#include <stdio.h>
#include <pthread.h>

#include "cthread.h"

typedef struct _CThread {
    void *args;
    Callback callback;
} _CThread;

void *runner(void *args);

CThread createThread(Callback callback, void *args)
{
    _CThread private = {
        .args = args,
        .callback = callback,
    };
    CThread t;


    t.private = malloc(sizeof(_CThread));
    *(_CThread *)(t.private) = private;

    return t;
}

CThreadStatus startThread(CThread *thread)
{
    _CThread *t = (_CThread *)thread->private;

    if (t == NULL) {
        return CThreadStatusErrorRestart;
    }

    int result = pthread_create(&thread->wrappedThread, NULL, runner, t);

    if (result != 0) {
        return CThreadStatusError;
    }

    return CThreadStatusOk;
}

void waitThread(CThread *thread)
{
    pthread_join(thread->wrappedThread, NULL);
}

#pragma mark - Private defenitions

void *runner(void *args)
{
    _CThread *t = args;

    t->callback(t->args);

    free(t);
    pthread_exit(NULL);
}
