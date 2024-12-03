#ifndef __CTHREAD_H__
#define __CTHREAD_H__

typedef void (*Callback)(void *args);

typedef enum CThreadStatus {
    CThreadStatusOk,
} CThreadStatus;

typedef struct CThread {
} CThread;

CThread createThread(Callback callback, void* args);
void startThread(CThread *thread);
CThreadStatus waitThread(CThread *thread);

#endif
