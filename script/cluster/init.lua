skynet_cluster = require "cluster"
require "script.cluster.netcluster"

cluster = cluster or {}

function cluster.init()
	local srvname = skynet.getenv("srvname")
	skynet_cluster.open(srvname)
	require "script.cluster.route"
	require "script.cluster.clustermgr"
	require "script.cluster.netcluster"
	require "script.cluster.warsrv"
	require "script.cluster.warsrvmgr"
	require "script.cluster.gamesrv"
	require "script.resume.resumemgr"

	netcluster.init()
	route.init()
	resumemgr.init()
	clustermgr.init()
	if cserver.iswarsrv() then
		warsrv.init()
	elseif cserver.iswarsrvmgr() then
		warsrvmgr.init()
	elseif cserver.isgamesrv() then
		gamesrv.init()
	end
end

function cluster.dispatch (session,source,issafecall,srvname,cmd,...)
	local rettbl = table.pack(pcall(cluster.__dispatch,session,source,srvname,cmd,...))
	local isok = rettbl[1]
	if isok then
		table.remove(rettbl,1)
		skynet.ret(skynet.pack(table.unpack(rettbl)))
	else
		local errmsg = rettbl[2]
		logger.log("error","onerror",errmsg)
		skynet.response()(false)
	end
end

function cluster.__dispatch(session,source,srvname,protoname,...)
	if protoname == "heartbeat" then
		require "script.cluster.clustermgr"
		return clustermgr.heartbeat(srvname)
	else
		local mod = assert(netcluster[protoname],string.format("[cluster] from %s,unkonw protoname:%s",srvname,protoname))
		return mod.dispatch(srvname,...)
	end
end

function cluster.call(srvname,protoname,cmd,...)
	local self_srvname = skynet.getenv("srvname")
	assert(srvname ~= self_srvname,"cluster call self,srvname:" .. tostring(srvname))
	local package = {...}
	logger.log("debug","netcluster",format("[call] srvname=%s protoname=%s cmd=%s package=%s",srvname,protoname,cmd,package))
	local ret = {skynet_cluster.call(srvname,".MAINSRV","cluster",self_srvname,protoname,cmd,...)}

	logger.log("debug","netcluster",format("[return] srvname=%s protoname=%s cmd=%s package=%s retval=%s",srvname,protoname,cmd,package,ret))
	return table.unpack(ret)

end

function cluster.pcall(srvname,protoname,cmd,...)
	return pcall(cluster.call,srvname,protoname,cmd,...)
end

return cluster


