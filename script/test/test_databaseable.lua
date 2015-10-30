require "script.base.databaseable"

local cdata = class("cdata",cdatabaseable)

function cdata:init(param)
	cdatabaseable.init(self,param)
	self.data = {}
end

local function test()
	local data = cdata.new({
		pid = 0,
		flag = "test",
	})
	assert(data:query("a.b.c.d")==nil)	
	data:set("a.b.c.d",3)
	assert(data:query("a.b.c.d")==3)
	data:add("a.b.c.d",2)
	assert(data:query("a.b.c.d"),5)
	assert(data:set("a.b.c.d","str")==5)
	assert(data:query("a.b.c.d")=="str")
	assert(not pcall(data.add,data,"a.b.c.d",5))
	assert(data:delete("a.b.c.d")=="str")
	assert(data:query("a.b.c.d")==nil)
	assert(data:query("key")==nil)
	assert(data:add("key",5)==nil)
	assert(data:query("key")==5)
	assert(data:basic_query("simplekey")==nil)
	assert(data:basic_set("simplekey","str")==nil)
	assert(data:basic_set("simplekey",3)=="str")
	assert(data:basic_add("simplekey",5)==3)
	assert(data:basic_query("simplekey")==8)

	-- invalid key
	assert(not pcall(data.query,data,"whitekey.a  b.isok"))
	assert(not pcall(data.query,data,"nonword.isok?"))
	assert(not pcall(data.query,data,"nonword.100%"))
	assert(not pcall(data.query,data,"nonword.100$"))

	-- valid key
	assert(pcall(data.query,data,"100"))
	assert(pcall(data.query,data,"100_a_b_c_100"))

	-- invalid operate
	data:set("key1.key2",4)
	assert(not pcall(data.set,data,"key1.key2.key3",5))
	pprintf("data:%s",data.data)
end

return test
