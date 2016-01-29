local function test(param)
	print(MAX_NUMBER)
	local citemdb = class("__citemdb",ccontainer)
	function citemdb:onclear(objs)
		print("onclear",objs)
	end
	function citemdb:onadd(obj)
		print("onadd",obj)
	end
	function citemdb:ondel(obj)
		print("ondel",obj)
	end
	function citemdb:onupdate(id,attrs)
		print("onupdate",id,attrs)
	end

	function citemdb:init(param)
		ccontainer.init(self,param)
	end

	function citemdb:save()
		local data = {}
		data.objid = self.objid
		local objs = {}
		for k,obj in pairs(self.objs) do
			table.insert(objs,obj)
		end
		data.objs = objs
		data.len = self.len
		return data
	end

	local citem = class("__citem")

	local itemdb = citemdb.new({
		pid = 0,
		name = "itemdb",
	})
	assert(itemdb.objid)
	local len = 10
	for i = 1,len do
		local obj = citem.new()
		itemdb:add(obj)
	end
	assert(itemdb.len==len)
	local id = itemdb.objid - 1
	assert(itemdb:get(id))
	itemdb:del(id)
	assert(itemdb:get(id)==nil)
	local obj = citem.new()
	itemdb:add(obj)
	assert(itemdb.len==len)
	pprintf("itemdb:%s",itemdb:save())
	itemdb:clear()
	assert(itemdb.len==0)
	pprintf("itemdb:%s",itemdb:save())
end

return test
