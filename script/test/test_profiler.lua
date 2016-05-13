require "script.profiler"

local function ignore_c(prof)
	local pos = string.find(prof.name,"%[C%]")
	return not (pos and pos >= 1)
end

local function test(...)
	local args = {...}
	if #args ~= 2 then
		print("Usage: test_profiler filename sort_key")
		return
	end
	local filename = args[1]
	local sort_key = args[2]
	local func = assert(loadfile(filename))
	profiler.init()
	profiler.start()
	func()
	profiler.stop()
	profiler.sort(sort_key)	
	profiler.dump(print,ignore_c)
end

--test(...)

return test
