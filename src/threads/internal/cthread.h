#ifndef __CTHREAD_H__
#define __CTHREAD_H__

#include <pthread.h>
#include <stdbool.h>

typedef struct CThreadParams {
    bool isDetached;
} CThreadParams;

static CThreadParams DEFAULT_PARAMS = {
    .isDetached = false,
};

typedef struct CThread {
    char *id;
    CThreadParams params;
    pthread_t wrappedThread;
    void *private;
} CThread;

typedef void (*Callback)(void *args);

typedef enum CThreadStatus {
    CThreadStatusOk,
    CThreadStatusErrorRestart,
    CThreadStatusError,
} CThreadStatus;

void *getArgs(CThread thread);
void setArgs(CThread *thread, void *args);

CThread *createThreadWithParams(CThreadParams params, Callback callback, void *args);
CThread *createThread(Callback callback, void *args);
CThreadStatus startThread(CThread *thread);
void waitThread(CThread *thread);

#endif
