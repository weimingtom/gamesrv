xml = require "LuaXml"

local xfile = xml.load("test.xml")
local strXml = xfile:str()
local xfile2 = xml.eval(strXml)
--assert(xfile:str() == xfile2:str())
--print(xfile)
--print(xfile2)
--xml.save(xfile,"mytest_1.xml")
--xml.save(xfile2,"mytest_2.xml")

assert(xfile:str() == xfile:str())


--print("dump xml object by kv:")
--for k,v in pairs(xfile) do
--	print(k,v)
--end

local xmlObj = xml.new({
	root_attr1 = "root_val1",
	root_attr2 = "root_val2",
	root_attr3 = 3,
	[0] = "root",
	{
		[0] = "child1",
		child1_attr1 = 1,
		child1_attr2 = 2,
	},
	{
		[0] = "child2",
		child2_attr1 = 1,
		child2_attr2 = 2,
	},

})

print(xmlObj:str())
