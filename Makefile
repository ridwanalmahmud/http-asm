all:
	nasm server.s -o bin/server.o
	ld server.o -o bin/server

clean:
	rm bin/server*
