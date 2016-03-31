LUACLIB ?= luaclib

all :
	cd crab && make all && cp *.so ../$(LUACLIB)
	cd lua-cjson && make all && cp cjson.so ../$(LUACLIB)
clean :
	-rm crab/*.so crab/crab
	cd lua-cjson && make clean
