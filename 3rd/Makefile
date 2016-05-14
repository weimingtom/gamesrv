LUACLIB ?= luaclib

all :
	mkdir -p $(LUACLIB)
	cd lua-cjson && make all && cp cjson.so ../$(LUACLIB)
	cd crab && make all && cp *.so ../$(LUACLIB)
	cd luaxml && make all && cp *.so ../$(LUACLIB)
	cd lua-snapshot && make all && cp *.so ../$(LUACLIB)
clean :
	-rm $(LUACLIB)/*.so
	-rm crab/*.so
	-rm luaxml/*.so
	-rm lua-snapshot/*.so
	cd lua-cjson && make clean
