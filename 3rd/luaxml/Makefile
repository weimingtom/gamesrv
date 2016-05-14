all: LuaXML_lib.so

LuaXML_lib.so : LuaXML_lib.c
	gcc -fPIC --shared -g -O0 -Wall -I/usr/local/include -o $@ $^ -L/usr/local/lib

test: all
	lua test.lua

clean:
	rm -f *.o LuaXML_lib.so
