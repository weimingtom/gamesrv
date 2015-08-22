
require "script.globalmgr"
require "script.cluster"
require "script.logger"
require "script.attrblock.saveobj"

friendmgr = friendmgr or {}

function friendmgr.init()
	friendmgr.objs = {}
	--friendmgr.autosave()
end

-- [[ TODO: DELETE
local delay = 300
local limit = 100000

function friendmgr.autosave()
	timer.timeout("timer.friendmgr",delay,friendmgr.autosave)
	print(friendmgr.objs,friendmgr.__idx)
	local cnt = 0
	for pid,frdblk in next,friendmgr.objs,friendmgr.__idx do
		cnt = cnt + 1
		if cnt > limit then
			break
		end
		friendmgr.__idx = pid
		if frdblk:updated() then
			local data = frdblk:save()
			db:set(db:key("friend",pid),data)
		end
	end
	if cnt < limit then
		friendmgr.__idx = nil
	end
end

-- TODO: DELETE]]

function friendmgr.loadfrdblk(pid)
	require "script.friend"
	local frdblk = cfriend.new(pid)
	frdblk:loadfromdatabase()
	return frdblk
end

function friendmgr.getfrdblk(pid)
	if not friendmgr.objs[pid] then
		local frdblk = friendmgr.loadfrdblk(pid)
		friendmgr.addfrdblk(pid,frdblk)
	end
	return friendmgr.objs[pid]
end

function friendmgr.addfrdblk(pid,frdblk)
	friendmgr.objs[pid] = frdblk
end

function friendmgr.delfrdblk(pid)
	local frdblk = friendmgr.objs[pid]
	friendmgr.objs[pid] = nil
	if frdblk then
		del_saveobj(frdblk)
		if cserver.isfrdsrv() then
		else
			cluster.call("frdsrv","friendmgr","delref",pid)
		end
	end
end


-- request
local CMD = {}
-- gamesrv --> frdsrv
function CMD.query(srvname,pid,key)
	local frdblk = friendmgr.getfrdblk(pid)
	frdblk:addref(srvname)
	local data = {}
	if key == "*" then
		data = frdblk:save()
	else
		data[key] = frdblk:query(key)
	end
	logger.log("debug","friendmgr",format("%s query,pid=%d key=%s data=%s",srvname,pid,key,data))
	return data
end

-- gamesrv -> frdsrv
function CMD.delref(srvname,pid)
	logger.log("debug","friendmgr",string.format("%s delref,pid=%d",srvname,pid))
	local frdblk = friendmgr.getfrdblk(pid)
	frdblk:delref(srvname)
end

-- frdsrv <-> gamesrv
function CMD.sync(srvname,pid,data)
	logger.log("debug","friendmgr",format("%s sync,pid=%d data=%s",srvname,pid,data))
	local frdblk = friendmgr.getfrdblk(pid)
	for k,v in pairs(data) do
		frdblk:set(k,v,true)
	end
	if frdblk.loadnull then
		frdblk.loadnull = nil
		frdblk:nowsave()
	end
	if cserver.isfrdsrv() then
		-- syncto frdsrv
		for srvname2,_ in pairs(frdblk.refs) do
			if srvname2 ~= srvname then
				cluster.call(srvname2,"friendmgr","sync",frdblk.pid,data)
			end
		end
	elseif cserver.isgamesrv() then
		-- syncto client
		for pid,_ in pairs(frdblk.refs) do
			sendpackage(pid,"friend","sync",data)
		end
	end
end

-- merge server need(frdsrv <-> gamesrv)
function CMD.updatepid(srvname,oldpid,newpid)
	logger.log("debug","friendmgr",string.format("%s updatepid,oldpid=%d newpid=%d",srvname,oldpid,newpid))
	local frdblk = friendmgr.getfrdblk(oldpid)
	if cserver.isfrdsrv() then
		for srvname2,_ in pairs(frdblk.refs) do
			if srvname2 ~= srvname then
				cluster.call(srvname2,"friendmgr","updatepid",oldpid,newpid)
			end
		end
	elseif cserver.isgamesrv() then
		for pid,_ in pairs(frdblk.refs) do
			local player = playermgr.getplayer(pid)
			if player then
				if findintable(player.frienddb.frdlist,oldpid) then
					player.frienddb:delfriend(oldpid)
					player.frienddb:addfriend(newpid)
				end
				if findintable(player.frienddb.applyerlist,oldpid) then
					player.frienddb:delapplyer(oldpid)
					player.frienddb:addapplyer(newpid)
				end
			end
		end
	end
end

function CMD.delete(srvname,pid)
	logger.log("debug","friendmgr",string.format("%s delete,pid=%d",srvname,pid))
	local frdblk = friendmgr.getfrdblk(pid)
	friendmgr.delfrdblk(pid)
	frdblk:deletefromdatabase()
end

function friendmgr.dispatch(srvname,cmd,...)
	assert(type(srvname)=="string","Invalid srvname:" .. tostring(srvname))
	local func = assert(CMD[cmd],"Unknow cmd:" .. tostring(cmd))
	return func(srvname,...)
end

return friendmgr
