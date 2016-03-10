
gm = require "script.gm.init"

--- cmd: test
--- usage: test test_filename json_str
function gm.test(args)
	local isok,args = checkargs(args,"string","string")
	if not isok then
		net.msg.notify(master.pid,"usage: test test_filename json_str")
		return
	end
	local test_filename = args[1]
	local func = require ("script.test." .. test_filename)
	local tbl = cjson.decode(args[2])
	print(format("test %s %s",test_filename,tbl))
	func(table.unpack(tbl)))
	print(string.format("test %s ok",test_filename))
end
return gm
