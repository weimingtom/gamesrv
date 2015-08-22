


local function docmd(srvname,methodname,...)
	local modname,funcname = string.match(methodname,"(.*)([.:].+)$")	
	if not (modname and funcname) then
		error("[modmethod] Invalid methodname:" .. tostring(methodname))
	end
	local mod
	if modname == "" then
		mod = _G
	else
		modname = "script." .. modname
		mod = require (modname)
	end
	local typ = funcname:sub(1,1)
	funcname = funcname:sub(2)
	local func = assert(mod[funcname],"[modmethod] Unknow methodname:" .. tostring(methodname))
	if typ == "." then
		return func(...)
	else
		return func(mod,...)
	end
end

netcluster_modmethod = netcluster_modmethod or {}

function netcluster_modmethod.dispatch(srvname,cmd,...)
	return docmd(srvname,cmd,...)
end

return netcluster_modmethod
