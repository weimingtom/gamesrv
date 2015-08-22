netcluster_friend = netcluster_friend or {}

local CMD = {}
function CMD.delfriend(srvname,pid)
end

function netcluster_friend.dispatch(srvname,cmd,...) 
	local func = assert(CMD[cmd],"[netcluster_base] Unknow cmd:" .. tostring(cmd))
	return func(srvname,...)
end

return netcluster_friend
