#include "cthread.h"

#include <stdio.h>

CThread createThread(Callback callback, void *args)
{
    CThread t = {};

    callback(args);

    printf("Created a thread\n");

    return t;
}

void startThread(CThread *thread)
{
    printf("Started a thread\n");
}

CThreadStatus waitThread(CThread *thread)
{
    printf("Waiting for thread to finish\n");

    return CThreadStatusOk;
}
