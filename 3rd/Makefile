LUACLIB ?= luaclib

all :
	mkdir -p $(LUACLIB)
	cd crab && make all && cp *.so ../$(LUACLIB)
	cd lua-cjson && make all && cp cjson.so ../$(LUACLIB)
clean :
	-rm $(LUACLIB)/*.so
	-rm crab/*.so
	cd lua-cjson && make clean
