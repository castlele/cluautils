CC=clang
CFLAGS=-arch arm64
ARCHIVE_CFLAGS=-shared -fPIC $(CFLAGS)

SRC_FOLDER=src
THREAD_SRC=$(SRC_FOLDER)/threads
THREAD_BIN=$(THREAD_SRC)/bin
THREAD_INTERNAL=$(THREAD_SRC)/internal
THREAD_INTERNAL_SRC=$(THREAD_INTERNAL)/cthread.c $(THREAD_INTERNAL)/clock.c $(THREAD_INTERNAL)/queue.c
THREAD_INTERNAL_BIN=libcthread.so
MEMORY_SRC=$(SRC_FOLDER)/memory
MEMORY_BIN=$(MEMORY_SRC)/bin

THREAD_INCLUDE=-I./$(THREAD_INTERNAL)/

THREAD_CFILES=$(THREAD_SRC)/thread.c
THREAD_BINARY=thread.so
MEMORY_CFILES=$(MEMORY_SRC)/cmemory.c
MEMORY_BINARY=cmemory.so


THREAD_LIBS=-L./$(THREAD_BIN)/ -lcthread
TEST_SRC=tests/cthread_internal_tests.c
TEST_BINARY=tests

LIBS=-llua -ldl -lm -I/Users/castlelecs/.luaver/lua/5.1/include/ -L/Users/castlelecs/.luaver/lua/5.1/lib/

build: build_thread build_memory

test_thread: compile_thread
	clear
	$(CC) $(THREAD_INCLUDE) $(THREAD_LIBS) $(TEST_SRC) -o $(THREAD_BIN)/$(TEST_BINARY)
	./$(THREAD_BIN)/$(TEST_BINARY)

build_memory:
	clear
	$(CC) $(ARCHIVE_CFLAGS) $(LIBS) $(MEMORY_CFILES) -o $(MEMORY_BIN)/$(MEMORY_BINARY)

build_thread: compile_thread
	clear
	$(CC) $(ARCHIVE_CFLAGS) $(LIBS) $(THREAD_LIBS) $(THREAD_INCLUDE) $(THREAD_CFILES) -o $(THREAD_BIN)/$(THREAD_BINARY)

compile_thread:
	clear
	$(CC) $(ARCHIVE_CFLAGS) $(THREAD_INTERNAL_SRC) $(THREAD_INCLUDE) -o $(THREAD_BIN)/$(THREAD_INTERNAL_BIN)

clean:
	clear
	rm -rf $(THREAD_BIN)/*
	rm -rf $(MEMORY_BIN)/*
