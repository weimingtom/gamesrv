
local function getcmd(t,cmd)
	local _cmd = string.format("return %s",cmd)
	t[cmd] = load(_cmd,"=(load)","bt",_G)
	return t[cmd]
end
local compile_cmd = setmetatable({},{__index=getcmd})

local function docmd(srvname,cmd,...)
	logger.log("debug","cluster","rpc",srvname,cmd,...)

	local attrname,sep,funcname = string.match(cmd,"^(.*)([.:])(.+)$")	
	local chunk = compile_cmd[attrname]
	local caller = chunk()
	if type(caller) == "function" then
		caller = caller()
	end
	local func = caller[funcname]
	if sep == "." then
		return func(...)
	else
		return func(caller,...)
	end
end

netcluster_rpc = netcluster_rpc or {}

function netcluster_rpc.dispatch(srvname,cmd,...)
	return docmd(srvname,cmd,...)
end

return netcluster_rpc
