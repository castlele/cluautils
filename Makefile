CC=clang
CFLAGS=-shared -fPIC -arch arm64

SRC=src/threads
BIN=$(SRC)/bin
INTERNAL=$(SRC)/internal
INTERNAL_SRC=$(INTERNAL)/cthread.c $(INTERNAL)/clock.c
INTERNAL_BIN=libcthread.so

INCLUDE=-I./$(INTERNAL)/

CFILES=$(SRC)/thread.c
BINARY=thread.so

TEST_LIBS=-L./$(BIN)/ -lcthread
TEST_SRC=tests/cthread_internal_tests.c
TEST_BINARY=tests

LIBS=-llua -ldl -lm -I/Users/castlelecs/.luaver/lua/5.1/include/ -L/Users/castlelecs/.luaver/lua/5.1/lib/

test: compile_lib
	clear
	$(CC) $(INCLUDE) $(TEST_LIBS) $(TEST_SRC) -o $(BIN)/$(TEST_BINARY)
	./$(BIN)/$(TEST_BINARY)

build: compile_lib
	clear
	$(CC) $(CFLAGS) $(LIBS) $(INCLUDE) $(CFILES) -o $(BIN)/$(BINARY)

compile_lib:
	clear
	$(CC) $(CFLAGS) $(INTERNAL_SRC) $(INCLUDE) -o $(BIN)/$(INTERNAL_BIN)

clean:
	clear
	rm -rf $(BIN)/*
