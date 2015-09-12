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
end

function clustermgr.checkserver()
	timer.timeout("clustermgr.checkserver",60,clustermgr.checkserver)
	local self_srvname = skynet.getenv("srvname")
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
	if oldstate ~= true then
		logger.log("info","cluster",string.format("server(%s->%s) connected",skynet.getenv("srvname"),srvname))
		if cserver.isfrdsrv(srvname) then
			broadcast(playermgr.allplayer(),"player","switch",{
				friend = true,
			})
		end
		route.syncto(srvname)
	end
end

function clustermgr.disconnect(srvname)
	local oldstate = clustermgr.connection[srvname]
	clustermgr.connection[srvname] = nil
	if oldstate == true then
		logger.log("critical","cluster",string.format("server(%s->%s) lost connect",skynet.getenv("srvname"),srvname))
		if cserver.isfrdsrv(srvname) then
			broadcast(playermgr.allplayer(),"player","switch",{
				friend = false,
			})
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

return clustermgr
