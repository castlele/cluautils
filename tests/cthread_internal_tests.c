#include <clock.h>
#include <cthread.h>
#include <queue.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
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
TestResult threadCanGetResultsOfThreadCallbackInWaitFunction();
TestResult mutextSynchronizesGlobalState();
TestResult argumentCanBeTakenFromThread();
TestResult argumentCanBeChangedAfterCreationOfTheThread();
TestResult queueIsEmptyMethodReturnsFalseIfEmpty();
TestResult queuePeekReturnsNullIfEmpty();
TestResult queuePushAddsElementToTheEnd();
TestResult queuePopReturnsFirstElementAndRemovesIt();
TestResult queuePopReturnsNullIfEmpty();
TestResult queueMultipleValuesCanBePushed();

TestResult (*tests[])() = {
    threadCanBeCreatedAndWaitedByParentThread,
    threadCanGetResultsOfThreadCallbackInWaitFunction,
    mutextSynchronizesGlobalState,
    argumentCanBeTakenFromThread,
    argumentCanBeChangedAfterCreationOfTheThread,
    queueIsEmptyMethodReturnsFalseIfEmpty,
    queuePeekReturnsNullIfEmpty,
    queuePushAddsElementToTheEnd,
    queuePopReturnsNullIfEmpty,
    queuePopReturnsFirstElementAndRemovesIt,
    queueMultipleValuesCanBePushed,
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
    char *id;
    bool isUsed;
} Argument;

int globalState;

void *testFunction(void *args)
{
    Argument *arg = (Argument *)args;
    arg->isUsed = true;
    return NULL;
}

void *returningFunction(void *args)
{
    void *ptr;
    ptr = "Done";

    return ptr;
}

void *addMillionGlobalState(void *args)
{
    CLock *lock = (CLock *)args;

    for (int i = 0; i < 1000000; i++) {
        mutexLock(lock);
        globalState++;
        mutexUnlock(lock);
    }
    return NULL;
}

TestResult threadCanBeCreatedAndWaitedByParentThread()
{
    Argument arg = { .id = "", .isUsed = false };
    CThread *sut = createThread(testFunction, (void *)&arg);

    CThreadStatus result = startThread(sut);
    waitThread(sut);

    free(sut);
    expect(result == CThreadStatusOk && arg.isUsed);
}

TestResult threadCanGetResultsOfThreadCallbackInWaitFunction()
{
    CThread *sut = createThread(returningFunction, NULL);

    CThreadStatus result = startThread(sut);
    void *waitingStatus = waitThread(sut);

    free(sut);
    expect(strcmp((char *)waitingStatus, "Done") == 0 && result == CThreadStatusOk);
}

TestResult mutextSynchronizesGlobalState()
{
    globalState = 0;
    int threadsCount = 4;
    int expectedResult = threadsCount*1000000;
    char errorMessage[300];
    CLock lock = createLock();
    CThread *sut[] = {
        createThread(addMillionGlobalState, (void *)&lock),
        createThread(addMillionGlobalState, (void *)&lock),
        createThread(addMillionGlobalState, (void *)&lock),
        createThread(addMillionGlobalState, (void *)&lock),
    };

    for (int i = 0; i < threadsCount; i++) {
        startThread(sut[i]);
    }

    for (int i = 0; i < threadsCount; i++) {
        waitThread(sut[i]);
        free(sut[i]);
    }

    sprintf(errorMessage, "Wrong sum. Expected %i, got: %i", expectedResult, globalState);
    expectWithMessage(globalState == expectedResult, errorMessage);
}

TestResult argumentCanBeTakenFromThread()
{
    Argument args = { .id = "Javie", .isUsed = true };
    CThread *sut = createThread(testFunction, &args);

    Argument *result = (Argument *)getArgs(*sut);

    free(sut);
    expect(result->isUsed && strcmp(args.id, result->id) == 0);
}

TestResult argumentCanBeChangedAfterCreationOfTheThread()
{
    Argument args = { .id = "Javie", .isUsed = false };
    Argument argToChange = { .id = "New Arg", .isUsed = true };
    CThread *sut = createThread(testFunction, &args);

    setArgs(sut, &argToChange);
    Argument *result = (Argument *)getArgs(*sut);

    free(sut);
    expect(result->isUsed && strcmp(argToChange.id, result->id) == 0);
}

TestResult queueIsEmptyMethodReturnsFalseIfEmpty()
{
    Queue *sut = initQueue();

    bool result = isEmpty(*sut);

    free(sut);
    expect(result);
}

TestResult queuePeekReturnsNullIfEmpty()
{
    Queue *sut = initQueue();

    void *result = peek(*sut);

    free(sut);
    expect(result == NULL);
}

TestResult queuePushAddsElementToTheEnd()
{
    int value = 10;
    Queue *sut = initQueue();

    push(sut, &value);
    int *result = (int *)peek(*sut);

    bool isEmptyStatus = isEmpty(*sut);
    free(sut);
    expect(!isEmptyStatus && *result == value);
}

TestResult queuePopReturnsNullIfEmpty()
{
    Queue *sut = initQueue();

    void *result = pop(sut);

    free(sut);
    expect(result == NULL);
}

TestResult queuePopReturnsFirstElementAndRemovesIt()
{
    int value = 10;
    Queue *sut = initQueue();
    push(sut, &value);

    int *result = (int *)pop(sut);

    bool isEmptyStatus = isEmpty(*sut);
    void *top = peek(*sut);
    free(sut);
    expect(isEmptyStatus && top == NULL && *result == value);
}

TestResult queueMultipleValuesCanBePushed()
{
    int values[] = { 10, 20, 30 };
    int n = sizeof(values) / sizeof(int);
    Queue *sut = initQueue();
    for (int i = 0; i < n; i++) {
        push(sut, &values[i]);
    }

    int results[3];
    for (int i = 0; i < n; i++) {
        int *value = pop(sut);
        results[i] = *value;
    }

    bool isEmptyStatus = isEmpty(*sut);
    void *top = peek(*sut);
    free(sut);
    expect(
        values[0] == results[0]
        && values[1] == results[1]
        && values[2] == results[2]
        && isEmptyStatus
        && top == NULL
    );
}
