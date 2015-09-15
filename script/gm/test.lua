
gm = require "script.gm.init"

--- usage: test test_filename ...
function gm.test(args)
	local ok,result = checkargs(slice(args,1,1),"string")
	if not ok then
		net.msg.notify(master.pid,"usage: test test_filename ...")
		return
	end
	local test_filename = table.unpack(result)
	local func = require ("script.test." .. test_filename)
	print(string.format("test %s ...",test_filename))
	for i = 2,#args do
		if tonumber(args[i]) then
			args[i] = tonumber(args[i])
		end
	end
	func(table.unpack(slice(args,2,#args)))
	print(string.format("test %s ok",test_filename))
end
return gm
