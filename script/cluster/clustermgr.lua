clustermgr = clustermgr or {}

-- 载入服务器列表
function clustermgr.loadconfig()
	local config_name = skynet.getenv "cluster"
	local f = assert(io.open(config_name))
	local source = f:read "*a"
	f:close()
	local tmp = {}
	assert(load(source, "@"..config_name, "t", tmp))()
	clustermgr.srvlist = tmp
	pprintf("srvlist:%s",clustermgr.srvlist)
	skynet_cluster.reload()
	print("skynet_cluster.reload ok")
end

function clustermgr.checkserver()
	timer.timeout("clustermgr.checkserver",60,clustermgr.checkserver)
	local self_srvname = cserver.getsrvname()
	for srvname,_ in pairs(clustermgr.srvlist) do
		if srvname ~= self_srvname then
			local ok,result = pcall(cluster.call,srvname,"heartbeat")
			if not ok then
				clustermgr.disconnect(srvname)
			else
				clustermgr.onconnect(srvname)
			end
		end
	end
end

function clustermgr.isconnect(srvname)
	return clustermgr.connection[srvname]
end

function clustermgr.onconnect(srvname)
	local oldstate = clustermgr.connection[srvname]
	clustermgr.connection[srvname] = true
	if not oldstate then
		logger.log("info","cluster",string.format("server(%s->%s) connected",cserver.getsrvname(),srvname))
		if cserver.isdatacenter(srvname) then
			playermgr.broadcast(function (player)
				sendpackage(player.pid,"player","switch",{
					friend = true,
				})
			end)
		end
		route.syncto(srvname)
	end
end

function clustermgr.disconnect(srvname)
	local oldstate = clustermgr.connection[srvname]
	clustermgr.connection[srvname] = nil
	if oldstate then
		logger.log("critical","cluster",string.format("server(%s->%s) lost connect",cserver.getsrvname(),srvname))
		if cserver.isdatacenter(srvname) then
			playermgr.broadcast(function (player)
				sendpackage(player.pid,"player","switch",{
					friend = false,
				})
			end)
		end
	end
end

function clustermgr.heartbeat(srvname)
	return true
end

function clustermgr.init()
	clustermgr.connection = {}
	clustermgr.srvlist = {}
	clustermgr.loadconfig()
	clustermgr.checkserver()
end

function __hotfix(oldmod)
	clustermgr.loadconfig()
end

return clustermgr
