

netcluster_forward = netcluster_forward or {}

function netcluster_forward.dispatch(srvname,pid,...)
	local player = playermgr.getplayer(pid)	
	if not player then
		return false
	end
	sendpackage(pid,...)
	return true
end

return netcluster_forward
