local skynet_cluster = require "cluster"
require "script.cluster.netcluster"

cluster = cluster or {}

function cluster.init()
	cluster.srvname = skynet.getenv("srvname")
	skynet_cluster.open(cluster.srvname)
	require "script.friend.friendmgr"
	require "script.cluster.route"
	require "script.cluster.clustermgr"
	require "script.cluster.netcluster"
	require "script.cluster.warsrv"
	require "script.cluster.warsrvmgr"
	require "script.cluster.gamesrv"
	netcluster.init()
	route.init()
	friendmgr.init()
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
		ret = clustermgr.heartbeat(srvname)
	else
		local mod = assert(netcluster[cmd],string.format("[cluster] from %s,unkonw cmd:%s",srvname,cmd))
		ret = mod.dispatch(srvname,...)
	end
	skynet.ret(skynet.pack(ret))
end

function cluster.call(srvname,protoname,cmd,...)
	assert(srvname ~= cluster.srvname,"cluster call self,srvname:" .. tostring(srvname))
	logger.log("debug","netcluster",format("[send] srvname=%s protoname=%s cmd=%s package=%s",srvname,protoname,cmd,{...}))
	return skynet_cluster.call(srvname,".mainservice","cluster",cluster.srvname,protoname,cmd,...)
end

return cluster


