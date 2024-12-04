#ifndef __CTHREAD_H__
#define __CTHREAD_H__

#include <pthread.h>

typedef struct CThread {
    pthread_t wrappedThread;
    void *private;
} CThread;

typedef void (*Callback)(void *args);

typedef enum CThreadStatus {
    CThreadStatusOk,
    CThreadStatusErrorRestart,
    CThreadStatusError,
} CThreadStatus;

CThread createThread(Callback callback, void *args);
CThreadStatus startThread(CThread *thread);
void waitThread(CThread *thread);

#endif
