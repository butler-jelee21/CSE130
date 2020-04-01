CFLAGS = -Wall -Isrc -lpthread
CC = gcc -g

SRC=$(wildcard src/*.c)

all: cat

cat: $(SRC)
	$(CC) -o $@ $^ $(CFLAGS) $(LIBS) 2>&1 | tee make.out

test: cat
	-@./cat

clean:
	@rm -f cat make.out