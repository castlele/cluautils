#ifndef __QUEUE_H__
#define __QUEUE_H__

#include <stdbool.h>

typedef struct Node {
    void *value;
    struct Node *next;
} Node;

typedef struct Queue {
    Node *head;
} Queue;

Queue *initQueue();

bool isEmpty(Queue q);
void *peek(Queue q);
void toString(Queue q);

void push(Queue *q, void *value);
void *pop(Queue *q);

#endif
