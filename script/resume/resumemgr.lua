
resumemgr = resumemgr or {}

function resumemgr.init()
	resumemgr.objs = {}
end

function resumemgr.oncreate(player)
	local pid = player.pid
	local data = player:packresume()
	resumemgr.create(pid,data)
end

function resumemgr.create(pid,data)
	require "script.resume.init"
	local resume = cresume.newtemp(pid)
	resume:create(data)
	return resume
end

function resumemgr.onlogin(player)
	local pid = player.pid
	local resume = resumemgr.getresume(pid)
	-- 兼容处理
	if not resume then
		resumemgr.create(player.pid,player:packresume())
	end
	resume = resumemgr.getresume(pid)
	resume:sync(player:packresume())
end

function resumemgr.onlogoff(player)
	local pid = player.pid
	local resume = resumemgr.getresume(pid)
	resume:sync(player:packresume())
end

function resumemgr.loadresume(pid)
	require "script.resume.init"
	local resume = cresume.new(pid)
	resume:loadfromdatabase()
	return resume
end

function resumemgr.getresume(pid)
	if not resumemgr.objs[pid] then
		local resume = resumemgr.loadresume(pid)
		if not resume.loadnull then
			resumemgr.addresume(pid,resume)
		end
	end
	return resumemgr.objs[pid]
end

function resumemgr.addresume(pid,resume)
	logger.log("info","resume",format("[addresume] pid=%d resume=%s",pid,resume:save()))
	resumemgr.objs[pid] = resume
end

function resumemgr.delresume(pid)
	local resume = resumemgr.objs[pid]
	resumemgr.objs[pid] = nil
	if resume then
		logger.log("info","resume",format("[delresume] pid=%d",pid))
		resume:savetodatabase()
		closesave(resume)
		local srvname = cserver.getsrvname()
		if cserver.isresumesrv(srvname) then
		else
			cluster.call("resumesrv","resumemgr","delref",pid)
		end
	end
end


-- request
local CMD = {}
-- gamesrv --> resumesrv
function CMD.query(srvname,pid,key)
	local resume = resumemgr.getresume(pid)
	if not resume then
		logger.log("warning","resume",string.format("[no resume] [query] srvname=%s pid=%s key=%s",srvname,pid,key))
		return
	end
	resume:addref(srvname)
	local data = {}
	if key == "*" then
		data = resume:save()
	else
		data[key] = resume:query(key)
	end
	logger.log("debug","resume",format("[query] srvname=%s pid=%d key=%s data=%s",srvname,pid,key,data))
	return data
end

-- gamesrv -> resumesrv
function CMD.delref(srvname,pid)
	logger.log("debug","resume",string.format("[delref] srvname=%s pid=%d",srvname,pid))
	local resume = resumemgr.getresume(pid)
	if not resume then
		return
	end
	resume:delref(srvname)
end

-- gamesrv -> resumesrv
function CMD.create(srvname,pid,data)
	data.pid = pid
	resumemgr.create(pid,data)
end

-- resumesrv <-> gamesrv
function CMD.sync(srvname,pid,data)
	logger.log("debug","resume",format("[sync] srvname=%s pid=%d data=%s",srvname,pid,data))
	data.pid = pid
	local resume = resumemgr.getresume(pid)
	if not resume then
		return
	end
	for k,v in pairs(data) do
		resume:set(k,v,true)
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
	logger.log("debug","resume",string.format("[delete] srvname=%s pid=%d",srvname,pid))
	local resume = resumemgr.getresume(pid)
	if resume then
		resumemgr.delresume(pid)
		resume:deletefromdatabase()
	end
end

function resumemgr.dispatch(srvname,cmd,...)
	assert(type(srvname)=="string","Invalid srvname:" .. tostring(srvname))
	local func = assert(CMD[cmd],"Unknow cmd:" .. tostring(cmd))
	return func(srvname,...)
end

return resumemgr
