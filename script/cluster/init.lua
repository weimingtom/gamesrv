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

function cluster.dispatch (session,source,srvname,cmd,...)
	--print("manservice.lua",session,source,srvname,cmd,...)
	local ret
	if cmd == "heartbeat" then
		require "script.cluster.clustermgr"
		skynet.ret(skynet.pack(clustermgr.heartbeat(srvname)))
	else
		local mod = assert(netcluster[cmd],string.format("[cluster] from %s,unkonw cmd:%s",srvname,cmd))
		skynet.ret(skynet.pack(mod.dispatch(srvname,...)))
	end
end

function cluster.call(srvname,protoname,cmd,...)
	local self_srvname = skynet.getenv("srvname")
	assert(srvname ~= self_srvname,"cluster call self,srvname:" .. tostring(srvname))
	logger.log("debug","netcluster",format("[send] srvname=%s protoname=%s cmd=%s package=%s",srvname,protoname,cmd,{...}))
	return skynet_cluster.call(srvname,".MAINSRV","cluster",self_srvname,protoname,cmd,...)
end

return cluster


