route = route or {}

function route.init()
	require "script.cluster.clustermgr"
	route.map = {}
	route.sync_state = {}
	local self_srvname = skynet.getenv("srvname")
	route.map[self_srvname] = {}
	local pids = route.map[self_srvname]
	local db = dbmgr.getdb()
	local pidlist = db:hkeys(db:key("role","list")) or {}
	print("server all pids:",#pidlist)
	for i,v in ipairs(pidlist) do
		pids[tonumber(v)] = true
	end
end

function route.getsrvname(pid)
	for srvname,pids in pairs(route.map) do
		if pids[pid] then
			return srvname
		end
	end
	--error("pid not map to a server,pid:" .. tostring(pid))
end

function route.addroute(pids,srvname)
	require "script.cluster.clustermgr"
	if type(pids) == "number" then
		pids = {pids,}
	end
	local self_srvname = skynet.getenv("srvname")
	srvname = srvname or self_srvname
	if not route.map[srvname] then
		route.map[srvname] = {}
	end
	for _,pid in ipairs(pids) do
		route.map[srvname][pid] = true
	end
	if srvname == self_srvname then
		for servername,_ in pairs(clustermgr.connection) do
			if servername ~= self_srvname then
				xpcall(cluster.call,onerror,servername,"route","addroute",pids)
			end
		end
	end
end

function route.delroute(pids,srvname)
	require "script.cluster.clustermgr"
	if type(pids) == "number" then
		pids = {pids,}
	end
	local self_srvname = skynet.getenv("srvname")
	srvname = srvname or self_srvname
	local pidlist = route.map[srvname]
	if pidlist then
		for _,pid in ipairs(pids) do
			pidlist[pid] = nil
		end
	end
	if srvname == self_srvname then
		for servername,_ in pairs(clustermgr.connection) do
			if servername ~= self_srvname then
				xpcall(cluster.call,onerror,servername,"route","delroute",pids)
			end
		end
	end
end

function route.syncto(srvname)
	xpcall(function ()
		local step = 5000
		local self_srvname = skynet.getenv("srvname")
		if not cserver.isgamesrv(self_srvname) or not cserver.isgamesrv(srvname) then
			return
		end
		local pidlist = route.map[self_srvname]
		pidlist = table.keys(pidlist)
		logger.log("debug","route",format("[syncto] server(%s->%s) pidlist=%s",skynet.getenv("srvname"),srvname,pidlist))
		for i = 1,#pidlist,step do
			cluster.call(srvname,"route","addroute",table.slice(pidlist,i,i+step-1))
		end
		cluster.call(srvname,"route","sync_finish")
	end,onerror)
end

local CMD = {}
function CMD.addroute(srvname,pids)
	logger.log("debug","route",format("[CMD.addroute] srvname=%s pids=%s",srvname,pids))
	route.addroute(pids,srvname)
end

function CMD.sync_finish(srvname)
	logger.log("debug","route",string.format("[CMD.sync_finish] srvname=%s",srvname))
	route.sync_state[srvname] = true
end

function CMD.delroute(srvname,pids)
	logger.log("debug","route",format("[CMD.delroute] srvname=%s pids=%s",srvname,pids))
	route.delroute(pids,srvname)
end

function route.dispatch(srvname,cmd,...)
	assert(cserver.isgamesrv(srvname),"[route.dispatch] Not a gamesrv:" .. tostring(srvname))
	local func = assert(CMD[cmd],"[route] Unknow cmd:" .. tostring(cmd))
	return func(srvname,...)
end

return route
