
require "script.war.init"
require "script.war.warmgr"

warsrv = warsrv or {}

function warsrv.init()
	warmgr.init()
end

local CMD = {}
-- warsrvmgr --> warsrv
function CMD.createwar(source,attacker,defenser)
	assert(source == "warsrvmgr","Invalid source:" .. source)
	if warmgr.num > 100000 then
		return false
	end
	local war = warmgr.createwar(source,attacker,defenser)
	war:startwar()
	war:s2csync()
	return true
end

function CMD.query_stat(source)
	assert(source == "warsrvmgr","Invalid source:" .. source)
	local stat = {
		num = warmgr.num,
	}
	return stat
end

function CMD.endwar(source,pid,warid)
	assert(source == "warsrvmgr","Invalid source:" .. source)
	local war = warmgr.getwar(warid)
	if not war then
		logger.log("warning","war",string.format("[warid=%d pid=%d srvname=%s] [no war] endwar",warid,pid,source))
		return
	end
	warmgr.endwar(warid,WAR_RESULT_TIE)
end

-- gamesrv --> warsrv
function CMD.giveupwar(source,request)
	local warid = assert(request.warid)
	local pid = assert(request.pid)
	local war = warmgr.getwar(warid)
	if not war then

		logger.log("warning","war",string.format("[warid=%d pid=%d srvname=%s] [no war] giveupwar",warid,pid,source))
		return
	end
	local warobj = war:getwarobj(pid)
	local result = warobj.pid == war.attacker.pid and WARRESULT_LOSE or WARRESULT_WIN
	warmgr.endwar(warid,result)
	--warobj.giveupwar = true
	--warmgr.check_endwar(warid)

end

function CMD.confirm_handcard(source,request)
	logger.log("debug","war",format("confirm_handcard,source=%s request=%s",source,request))
	local warid = assert(request.warid)
	local pid = assert(request.pid)
	local war = warmgr.getwar(warid)
	if not war then
		logger.log("warning","war",string.format("[warid=%d pid=%d srvname=%s] [no war] confirm_handcard",warid,pid,source))
		return
	end
	local warobj = war:getwarobj(pid)
	if warobj.state ~= "ready_handcard" then
		logger.log("warning","war",string.format("[warid=%d pid=%d srvname=%s] [state ~= ready_handcard] confirm_handcard",warid,pid,source))
		return
	end
	local ids = assert(request.ids)
	warobj:confirm_handcard(ids)
	if warobj.enemy.state == "confirm_handcard" then
		if warobj.type == "attacker" then
			warobj:beginround()
		else
			warobj.enemy:beginround()
		end
		war:s2csync()
	end
	warmgr.check_endwar(warid)
end

function CMD.endround(source,request)
	local warid = assert(request.warid)
	local pid = assert(request.pid)
	local war = warmgr.getwar(warid)
	if not war then
		logger.log("warning","war",string.format("[warid=%s pid=%s srvname=%s] [no war] endround",warid,pid,source))
		return
	end
	local warobj = war:getwarobj(pid)
	if warobj.state ~= "beginround" then
		return
	end
	local roundcnt = assert(request.roundcnt)
	-- endround will call war:s2csync(),and maybe endwar
	warobj:endround(roundcnt)
	warmgr.check_endwar(warid)
end

function CMD.playcard(source,request)
	local warid = assert(request.warid)
	local pid = assert(request.pid)
	local war = warmgr.getwar(warid)
	if not war then

		logger.log("warning","war",string.format("[warid=%s pid=%s srvname=%s] [no war] playcard",warid,pid,source))
		return
	end
	local warobj = war:getwarobj(pid)
	if warobj.state ~= "beginround" then
		return
	end
	local id = assert(request.id)
	local pos = request.pos
	local targetid = request.targetid
	local choice = request.choice
	warobj:playcard(id,pos,targetid,choice)
	war:s2csync()
	warmgr.check_endwar(warid)
end

function CMD.launchattack(source,request)
	local warid = assert(request.warid)
	local pid = assert(request.pid)
	local war = warmgr.getwar(warid)
	if not war then

		logger.log("warning","war",string.format("[warid=%s pid=%s srvname=%s] [no war] launchattack",warid,pid,source))
		return
	end
	local warobj = war:getwarobj(pid)
	if warobj.state ~= "beginround" then
		return
	end
local id = assert(request.id)
	local targetid = assert(request.targetid)
	war:s2csync()
	warmgr.check_endwar(warid)
end

function CMD.useskill(source,request)
	local warid = assert(request.warid)
	local pid = assert(request.pid)
	local war = warmgr.getwar(warid)
	if not war then
		logger.log("warning","war",string.format("[warid=%s pid=%s srvname=%s] [now war] useskill",warid,pid,source))
		return
	end
	local warobj = war:getwarobj(pid)
	if warobj.state ~= "beginround" then
		return
	end
	local targetid = request.targetid
	warobj:useskill(targetid)
	war:s2csync()
	warmgr.check_endwar(warid)
end

function CMD.lookcards_confirm(source,request)
	local warid = assert(request.warid)
	local pid = assert(request.pid)
	local war = warmgr.getwar(warid)
	if not war then
		logger.log("warning","war",string.format("[warid=%s pid=%s srvname=%s] [no war] lookcards_confirm",warid,pid,source))
		return
	end
	local warobj = war:getwarobj(pid)
	if warobj.state ~= "beginround" then
		return
	end
	local pos = assert(request.pos)
	warobj:lookcards_confirm(pos)
	war:s2csync()
	warmgr.check_endwar(warid)
end

function CMD.playcard(source,request)
	local warid = assert(request.warid)
	local pid = assert(request.pid)
	local war = warmgr.getwar(warid)
	if not war then
		logger.log("warning","war",string.format("[warid=%s pid=%s srvname=%s] [no war] lookcards_confirm",warid,pid,source))
		return
	end
	local warobj = war:getwarobj(pid)
	if warobj.state ~= "beginround" then
		return
	end
	local id = assert(request.id)
	local pos = request.pos
	local targetid = request.targetid
	local choice = request.choice
	warobj:playcard(id,pos,targetid,choice)
	warmgr.check_endwar(warid)
end

function CMD.disconnect(source,request)
	local warid = assert(request.warid)
	local pid = assert(request.pid)
	warmgr.check_endwar(warid)
end

function warsrv.dispatch(source,cmd,...)
	assert(type(source)=="string","Invalid source:" .. tostring(source))
	local func = assert(CMD[cmd],"Unknow cmd:" .. tostring(cmd))
	return func(source,...)
end

return warsrv
