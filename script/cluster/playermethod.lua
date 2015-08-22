


local function docmd(srvname,pid,methodname,...)
	local player = playermgr.getplayer(pid)	
	if not player then
		player = playermgr.loadofflineplayer(pid,"all")
	end
	assert(player,"Not found pid:" .. tostring(pid))
	local modname,funcname = string.match(methodname,"(.*)([.:].+)$")	
	if not (modname and funcname) then
		error("[modmethod] Invalid methodname:" .. tostring(methodname))
	end
	local mod = player
	if modname ~= "" then
		local attrs = {}
		for attr in string.gmatch(modname,"([^.]+)") do
			mod = mod[attr]
		end
	end
	local typ = funcname:sub(1,1)
	funcname = funcname:sub(2)
	local func = assert(mod[funcname],"[modmethod] Unknow methodname:" .. tostring(methodname))
	if typ == "." then
		return func(...)
	elseif typ == ":" then
		return func(mod,...)
	else
		error("Invalid function seperator:" .. tostring(typ))
	end
end

netcluster_playermethod = netcluster_playermethod or {}

function netcluster_playermethod.dispatch(srvname,cmd,...)
	return docmd(srvname,cmd,...)
end

return netcluster_playermethod
