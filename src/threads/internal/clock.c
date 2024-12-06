#include <pthread.h>

#include "clock.h"

CLock createLock()
{
    pthread_mutex_t mutex;
    pthread_mutex_init(&mutex, NULL);
    CLock lock = { .wrappedMutex = mutex, };

    return lock;
}

void mutexLock(CLock *lock)
{
    pthread_mutex_lock(&lock->wrappedMutex);
}

void mutexUnlock(CLock *lock)
{
    pthread_mutex_unlock(&lock->wrappedMutex);
}

void destroyLock(CLock *lock)
{
    pthread_mutex_destroy(&lock->wrappedMutex);
}
