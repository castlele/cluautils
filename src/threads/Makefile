CC=clang
CFLAGS=-shared -fPIC -arch arm64

CFILES=thread.c
BIN=thread.so

LIBS=-llua -ldl -lm -I/Users/castlelecs/.luaver/lua/5.1/include/ -L/Users/castlelecs/.luaver/lua/5.1/lib/

run:
	love .

build:
	clear
	$(CC) $(CFLAGS) $(LIBS) $(CFILES) -o $(BIN)

clean:
	clear
	rm $(BIN)
