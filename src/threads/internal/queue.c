#include <stdlib.h>
#include <unistd.h>
#include <stdio.h>

#include "queue.h"

Queue *initQueue()
{
    Queue *q = malloc(sizeof(Queue));
    q->head = NULL;

    return q;
}

bool isEmpty(Queue q)
{
    return peek(q) == NULL;
}

void *peek(Queue q)
{
    if (q.head) {
        return q.head->value;
    }

    return NULL;
}


void push(Queue *q, void *value)
{
    Node *newNode = malloc(sizeof(Node));
    newNode->value = value;
    newNode->next = NULL;

    if (isEmpty(*q)) {
        q->head = newNode;
        return;
    }

    Node *current = q->head;

    while (current->next != NULL) {
        current = current->next;
    }

    current->next = newNode;
}

void *pop(Queue *q)
{
    if (isEmpty(*q)) return NULL;

    Node *head = q->head;

    q->head = head->next;

    void *value = head->value;
    free(head);

    return value;
}
