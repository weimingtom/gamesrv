


local function docmd(srvname,methodname,...)
	local modname,sep,funcname = string.match(methodname,"^(.*)([.:])(.+)$")	
	if not (modname and sep and funcname) then
		error("[modmethod] Invalid methodname:" .. tostring(methodname))
	end
	local mod
	if modname == "" then
		mod = _G
	else
		modname = "script." .. modname
		mod = require (modname)
	end
	local func = assert(mod[funcname],"[modmethod] Unknow methodname:" .. tostring(methodname))
	if sep == "." then
		return func(...)
	elseif sep == ":":
		return func(mod,...)
	else
		error("Invalid function seperator:" .. tostring(typ))
	end
end

netcluster_modmethod = netcluster_modmethod or {}

function netcluster_modmethod.dispatch(srvname,cmd,...)
	return docmd(srvname,cmd,...)
end

return netcluster_modmethod
