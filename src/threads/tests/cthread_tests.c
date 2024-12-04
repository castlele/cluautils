#include <cthread.h>
#include <stdio.h>
#include <string.h>
#include <stdbool.h>

#pragma mark - Utils

typedef struct TestResult {
    bool status;
    char *message;
} TestResult;

#define expectWithMessage(condition, m) \
    TestResult r; \
    r.status = (condition); \
    r.message = (m); \
    return r;

#define expect(condition) expectWithMessage(condition, NULL)

void test(TestResult (*func)())
{
    TestResult res = func();

    if (res.status) {
        printf("Test '%s' passed successfuly!\n", __func__);
    } else {
        printf("Test '%s' failed!\n", __func__);

        if (res.message) {
            printf("\t%s\n", res.message);
        }
    }
}

#pragma mark - Test Cases List

TestResult threadCanBeCreatedAndWaitedByParentThread();

TestResult (*tests[])() = {
    threadCanBeCreatedAndWaitedByParentThread,
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

void testFunction(void *args)
{
    Argument *arg = (Argument *)args;
    arg->isUsed = true;
}

TestResult threadCanBeCreatedAndWaitedByParentThread()
{
    Argument arg = { .isUsed = false };
    CThread sut = createThread(testFunction, (void *)&arg);

    CThreadStatus result =startThread(&sut);
    waitThread(&sut);

    expect(result == CThreadStatusOk && arg.isUsed);
}
