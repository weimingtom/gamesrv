require "script.skynet"

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

function needret_retpack(noret,...)
	if noret ~= NORET then
		skynet.ret(skynet.pack(...))
	end
end

skynet.start(function ()
	skynet.dispatch("lua",function (session,source,cmd,...)
		local func = CMD[cmd]
		needret_retpack(func(...))
	end)
end)
