#include <cthread.h>
#include <clock.h>
#include <stdio.h>
#include <string.h>
#include <stdbool.h>
#include <unistd.h>

#pragma mark - Utils

typedef struct TestResult {
    bool status;
    char *name;
    char *message;
} TestResult;

#define expectWithMessage(condition, m) \
    TestResult r; \
    r.status = (condition); \
    r.name = strdup(__func__); \
    r.message = (m); \
    return r;

#define expect(condition) expectWithMessage(condition, NULL)

void test(TestResult (*func)())
{
    TestResult res = func();

    if (res.status) {
        printf("Test '%s' passed successfuly!\n", res.name);
    } else {
        printf("Test '%s' failed!\n", res.name);

        if (res.message) {
            printf("\t%s\n", res.message);
        }
    }
}

#pragma mark - Test Cases List

TestResult threadCanBeCreatedAndWaitedByParentThread();
TestResult mutextSynchronizesGlobalState();

TestResult (*tests[])() = {
    threadCanBeCreatedAndWaitedByParentThread,
    mutextSynchronizesGlobalState,
};


#pragma mark - Main

int main()
{
    int testsAmount = sizeof(tests) / sizeof(tests[0]);

    for (int index = 0; index < testsAmount; index++) {
        test(tests[index]);
    }

    return 0;
}

#pragma mark - Test Cases Implementation

typedef struct Argument {
    bool isUsed;
} Argument;

int globalState;

void testFunction(void *args)
{
    Argument *arg = (Argument *)args;
    arg->isUsed = true;
}

void addMillionGlobalState(void *args)
{
    CLock *lock = (CLock *)args;

    for (int i = 0; i < 1000000; i++) {
        mutexLock(lock);
        globalState++;
        mutexUnlock(lock);
    }
}

TestResult threadCanBeCreatedAndWaitedByParentThread()
{
    Argument arg = { .isUsed = false };
    CThread sut = createThread(testFunction, (void *)&arg);

    CThreadStatus result =startThread(&sut);
    waitThread(&sut);

    expect(result == CThreadStatusOk && arg.isUsed);
}

TestResult mutextSynchronizesGlobalState()
{
    globalState = 0;
    int threadsCount = 4;
    int expectedResult = threadsCount*1000000;
    char errorMessage[300];
    CLock lock = createLock();
    CThread sut[] = {
        createThread(addMillionGlobalState, (void *)&lock),
        createThread(addMillionGlobalState, (void *)&lock),
        createThread(addMillionGlobalState, (void *)&lock),
        createThread(addMillionGlobalState, (void *)&lock),
    };

    for (int i = 0; i < threadsCount; i++) {
        startThread(&sut[i]);
    }

    for (int i = 0; i < threadsCount; i++) {
        waitThread(&sut[i]);
    }

    sprintf(errorMessage, "Wrong sum. Expected %i, got: %i", expectedResult, globalState);
    expectWithMessage(globalState == expectedResult, errorMessage);
}
