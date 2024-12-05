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

CThread createThreadWithParams(CThreadParams params, Callback callback, void *args);
CThread createThread(Callback callback, void *args);
CThreadStatus startThread(CThread *thread);
void waitThread(CThread *thread);

#endif
