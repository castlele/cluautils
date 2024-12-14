#ifndef __CLOCK_H__
#define __CLOCK_H__

#include <pthread.h>

typedef struct CLock {
    pthread_mutex_t wrappedMutex;
} CLock;

CLock createLock();
void mutexLock(CLock *lock);
void mutexUnlock(CLock *lock);
void destroyLock(CLock *lock);

#endif
