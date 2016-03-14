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

function cluster.__dispatch(session,source,srvname,cmd,...)
	if cmd == "heartbeat" then
		require "script.cluster.clustermgr"
		return clustermgr.heartbeat(srvname)
	else
		local mod = assert(netcluster[cmd],string.format("[cluster] from %s,unkonw cmd:%s",srvname,cmd))
		local ret = {mod.dispatch(srvname,...)}
		logger.log("debug","netcluster",format("[return] srvname=%s session=%s retval=%s",srvname,session,ret))
		return table.unpack(ret)
	end
end

function cluster.call(srvname,protoname,cmd,...)
	local self_srvname = skynet.getenv("srvname")
	assert(srvname ~= self_srvname,"cluster call self,srvname:" .. tostring(srvname))
	logger.log("debug","netcluster",format("[call] srvname=%s protoname=%s cmd=%s package=%s",srvname,protoname,cmd,{...}))
	return skynet_cluster.call(srvname,".MAINSRV","cluster",nil,self_srvname,protoname,cmd,...)
end

function cluster.pcall(srvname,protoname,cmd,...)
	local self_srvname = skynet.getenv("srvname")
	assert(srvname ~= self_srvname,"cluster call self,srvname:" .. tostring(srvname))
	logger.log("debug","netcluster",format("[pcall] srvname=%s protoname=%s cmd=%s package=%s",srvname,protoname,cmd,{...}))
	return skynet_cluster.call(srvname,".MAINSRV","cluster",true,self_srvname,protoname,cmd,...)
end

return cluster


