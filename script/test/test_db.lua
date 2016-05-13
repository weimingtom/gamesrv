
local function test()
	local tblname = "test"
	dbmgr.init()
	local db = dbmgr.getdb()
	print(db:set(tblname .. ":key1",1))
	print(db:get(tblname .. ":key1"))
	print(db:del(tblname .. ":key1"))
	local value = {
		test = {
			test1 = {
				test2 = 'ok',
			},
			good = 3,
		},
		hello = 'world',
		[1] = "one",
		[100] = "hundread",
		[1000] = "thousand",
	}
	print(db:set(tblname .. ":tblkey",value))
	pprintf("%s",db:get(tblname .. ":tblkey"))
end


function __hotfix(oldmod)
	print('okhhaa')
end

print("hotfix",__hotfix)

return test

