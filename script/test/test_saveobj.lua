local function test()
	local ctest = class("ctest")
	function ctest:init(id)
		self.id = id
		self.savename = string.format("ctest.%s",self.id)
		autosave(self)
	end

	function ctest:savetodatabase()
		print("savetodatabase",self.id)
	end

	local o1 = ctest.new(1)
	local o2 = ctest.new(2)
	nowsave(o1)
	nowsave(o2)

	-- change autosave to oncesave
	local isok,msg = pcall(oncesave,o1)
	assert(not isok)
	print(msg)

	-- call clearsavetype before change autosave to oncesave
	clearsavetype(o1)
	local isok = pcall(oncesave,o1)
	assert(isok)
	nowsave(o1)

	-- call clearsavetype before change oncesave to autosave
	clearsavetype(o1)
	local isok = pcall(autosave,o1)
	assert(isok)
	nowsave(o1)

	mergeto(o2,o1)
	nowsave(o1)

	closesave(o1)
	closesave(o2)
end

return test
