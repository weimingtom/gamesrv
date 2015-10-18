local skynet = require "script.skynet"
local redis = require "redis"

local conn = nil
-- ignore watch

local command = {}
function command.connect(conf)
	conn = redis.connect(conf)
end

function command.disconnect()
	if conn then
		conn:disconnect()
	end
end

skynet.start(function ()
	skynet.dispatch("lua",function (session,source,cmd,...)
		if type(cmd) == "table" then
			for k,v in pairs(cmd) do
				print(k,v)
			end
		end
		local isok,result = false,"unknow cmd"
		local func = command[cmd]
		if func then
			isok,result = pcall(func,...)
		else
			func = conn[cmd]
			if func then
				isok,result = pcall(func,conn,...)
			end
		end
		if isok then
			skynet.ret(skynet.pack(result))
		else
			skynet.error(result)
		end
	end)
end)
