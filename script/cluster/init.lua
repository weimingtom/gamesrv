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
	--print("manservice.lua",session,source,issafecall,srvname,cmd,...)
	if not issafecall then	
		skynet.ret(skynet.pack(cluster.__dispatch(session,source,srvname,cmd,...)))
	else
		-- xpcall 无法返回错误消息
		skynet.ret(skynet.pack(xpcall(cluster.__dispatch,onerror,session,source,srvname,cmd,...)))
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
	return cluster._call(false,srvname,protoname,cmd,...)
end

function cluster.pcall(srvname,protoname,cmd,...)
	return cluster._call(true,srvname,protoname,cmd,...)
end

function cluster._call(issafecall,srvname,protoname,cmd,...)
	local self_srvname = skynet.getenv("srvname")
	assert(srvname ~= self_srvname,"cluster call self,srvname:" .. tostring(srvname))
	local package = {...}
	logger.log("debug","netcluster",format("[call] issafecall=%s srvname=%s protoname=%s cmd=%s package=%s",issafecall,srvname,protoname,cmd,package))
	local ret = {skynet_cluster.call(srvname,".MAINSRV","cluster",issafecall,self_srvname,protoname,cmd,...)}

	logger.log("debug","netcluster",format("[return] issafecall=%s srvname=%s protoname=%s cmd=%s package=%s retval=%s",issafecall,srvname,protoname,cmd,package,ret))
	return table.unpack(ret)
end

return cluster


