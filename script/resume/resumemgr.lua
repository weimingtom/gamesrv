
resumemgr = resumemgr or {}

function resumemgr.init()
	resumemgr.objs = {}
end

function resumemgr.oncreate(player)
	local pid = player.pid
	local resume = cresume.newtemp(pid)
	resume:create(player)
end

function resumemgr.onlogin(player)
	local pid = player.pid
	local resume = resumegr.getresume(pid)
	resume:sync(player:packresume())
end

function resumemgr.onlogoff(player)
	local pid = player.pid
	local resume = resumegr.getresume(pid)
	resume:sync(player:packresume())
end

function resumemgr.loadresume(pid)
	require "script.friend"
	local resume = cresume.new(pid)
	resume:loadfromdatabase()
	return resume
end

function resumemgr.getresume(pid)
	if not resumemgr.objs[pid] then
		local resume = resumemgr.loadresume(pid)
		resumemgr.addresume(pid,resume)
	end
	return resumemgr.objs[pid]
end

function resumemgr.addresume(pid,resume)
	resumemgr.objs[pid] = resume
end

function resumemgr.delresume(pid)
	local resume = resumemgr.objs[pid]
	resumemgr.objs[pid] = nil
	if resume then
		del_saveobj(resume)
		local srvname = cserver.srvname
		if cserver.isresumesrv(srvname) then
		else
			cluster.call("resumesrv","resumemgr","delref",srvname)
		end
	end
end


-- request
local CMD = {}
-- gamesrv --> resumesrv
function CMD.query(srvname,pid,key)
	local resume = resumemgr.getresume(pid)
	resume:addref(srvname)
	local data = {}
	if key == "*" then
		data = resume:save()
	else
		data[key] = resume:query(key)
	end
	logger.log("debug","resumemgr",format("%s query,pid=%d key=%s data=%s",srvname,pid,key,data))
	return data
end

-- gamesrv -> resumesrv
function CMD.delref(srvname,pid)
	logger.log("debug","resumemgr",string.format("%s delref,pid=%d",srvname,pid))
	local resume = resumemgr.getresume(pid)
	resume:delref(srvname)
end

-- resumesrv <-> gamesrv
function CMD.sync(srvname,pid,data)
	logger.log("debug","resumemgr",format("%s sync,pid=%d data=%s",srvname,pid,data))
	local resume = resumemgr.getresume(pid)
	for k,v in pairs(data) do
		resume:set(k,v,true)
	end
	if resume.loadnull then
		resume.loadnull = nil
		resume:nowsave()
	end
	if cserver.isresumesrv() then
		-- syncto gamesrv
		for srvname2,_ in pairs(resume.srvname_ref) do
			if srvname2 ~= srvname then
				cluster.call(srvname2,"resumemgr","sync",resume.pid,data)
			end
		end
	elseif cserver.isgamesrv() then
		-- syncto client
		for pid,_ in pairs(resume.pid_ref) do
			sendpackage(pid,"friend","sync",data)
		end
	end
end

function CMD.delete(srvname,pid)
	logger.log("debug","resumemgr",string.format("%s delete,pid=%d",srvname,pid))
	local resume = resumemgr.getresume(pid)
	resumemgr.delresume(pid)
	resume:deletefromdatabase()
end

function resumemgr.dispatch(srvname,cmd,...)
	assert(type(srvname)=="string","Invalid srvname:" .. tostring(srvname))
	local func = assert(CMD[cmd],"Unknow cmd:" .. tostring(cmd))
	return func(srvname,...)
end

return resumemgr
