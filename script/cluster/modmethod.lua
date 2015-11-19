


local function docmd(srvname,modname,methodname,...)
	modname = modname or ""
	if not string.find(methodname,"[.:]") then
		methodname = "." .. methodname
	end
	local attrname,sep,funcname = string.match(methodname,"^(.*)([.:])(.+)$")	
	if not (attrname and sep and funcname) then
		error(string.format("[modmethod] Unknow modname=%s methodname=%s",modname,methodname))
	end
	local mod
	if modname == "" then
		mod = _G
	else
		modname = "script." .. modname
		mod = require (modname)
	end
	if attrname then
		for attr in string.gmatch(attrname,"[^.]+") do
			mod = mod[attr]
		end
	end
	local func = assert(mod[funcname],string.format("[modmethod] Unknow modname=%s methodname=%s",modname,methodname))
	if type(func) ~= "function" then
		assert(sep == ".")
		return func
	end
	if sep == "." then
		return func(...)
	elseif sep == ":" then
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
