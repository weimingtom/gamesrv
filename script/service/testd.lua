require "script.skynet"

local NORET = NORET or {}
local CMD = {}
function CMD.error(...)
	error(...)
end

function CMD.assert(a,b)
	assert(a==b)
end

function CMD.noret(...)
	return NORET
end

function CMD.ret(...)
	return ...
end

function CMD.retfalse()
	skynet.ret(skynet.pack(false))
end

function CMD.retfalse2()
	skynet.response()(false)
end

function needret_retpack(noret,...)
	if noret ~= NORET then
		skynet.ret(skynet.pack(...))
	end
end

skynet.init(function ()
	print("skynet.init")
end)

skynet.start(function ()
	print("skynet.start")
	skynet.dispatch("lua",function (session,source,cmd,...)
		print(session,source,cmd,...)
		local func = CMD[cmd]
		needret_retpack(func(...))
	end)
end)

print("module code")
