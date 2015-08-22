local skynet = require "skynet"


local function err()
	local var1 = 1
	local var2 = "string"
	local var3 = {1,2,one=1}
	local id = 5
	local player = {name='lgl',pid=3,id=5,}
	error("error msg")
end

local function assert_fail()
	local var1 = 1
	local var2 = "string"
	local var3 = {1,2,one=1}
	local pid = 4
	assert(0==1,"assert msg")
end

local function arithmetic_fail()
	local a = 1
	local b = 0
	local c = a.b + 1
end

local function functor_fail()
	local a = 1
	local b = 0
	local c = a.b + 1
end


local function collect_localvar(level)
	local function dumptable(tbl) 
		local attrs = {"pid","id","name","sid","warid","flag",}
		local tips = {}
		for _,attr in ipairs(attrs) do
			if tbl[attr] then
				table.insert(tips,string.format("\t%s=%s",attr,tbl[attr]))
			end
		end
		return tips
	end

	local ret = {}
	local i = 0
	while true do
		i = i + 1
		local name,value = debug.getlocal(level,i)
		if not name then
			break
		end
		
		table.insert(ret,string.format("%s=%s",name,value))
		if type(value) == "table" then
			local tips = dumptable(value)
			if #tips > 0 then
				table.insert(ret,table.concat(tips,"\n"))
			end
		end
	end
	return ret
end

local function onerror(msg)
	local level = 4
	pcall(function ()
		-- assert/error触发(需要搜集level+1层--调用assert/error函数所在层)
		-- 代码逻辑直接触发搜集level层即可
		local vars = collect_localvar(level+1)
		table.insert(vars,"================")
		local vars2 = collect_localvar(level+2)
		for _,s in ipairs(vars2) do
			table.insert(vars,s)
		end

		table.insert(vars,1,string.format("error: [%s] %s",os.date("%Y-%m-%d %H:%M:%S"),msg))
		local msg = debug.traceback(table.concat(vars,"\n"),level)
		skynet.error(msg)
	end)
end

local function test()
	xpcall(err,onerror)
	xpcall(assert_fail,onerror)
	xpcall(arithmetic_fail,onerror)
	xpcall(functor(functor_fail),onerror)
end

return test
