
require "script.war.init"
require "script.war.warmgr"

warsrv = warsrv or {}

function warsrv.init()
	warmgr.init()
end

local CMD = {}
-- warsrvmgr --> warsrv
function CMD.createwar(source,profile1,profile2)
	assert(source == "warsrvmgr","Invalid source:" .. source)
	if warmgr.num > 100000 then
		return false
	end
	local war = warmgr.createwar(profile1,profile2)
	warmgr.addwar(war)
	cluster.call(source,"war","startwar",profile1.pid,war.warid)
	cluster.call(source,"war","startwar",profile2.pid,war.warid)
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
		logger.log("warning","war",string.format("#%d endwar(warid not exists),source=%d warid=%d",pid,source,warid))
		return
	end
	warmgr.endwar(warid,WAR_RESULT_TIE)
end

-- gamesrv --> warsrv
function CMD.giveupwar(source,warid,pid,request)
	local war = warmgr.getwar(warid)
	if not war then
		logger.log("warning","war",string.format("#%d giveupwar(warid not exists),source=%d warid=%d",pid,source,warid))
		return
	end
	local warobj = war:getwarobj(pid)
	warobj:endwar(WAR_RESULT_LOSE)
end

function CMD.confirm_handcard(source,warid,pid,request)
	local war = warmgr.getwar(warid)
	if not war then
		logger.log("warning","war",string.format("[warid=%s pid=%s srvname=%s] [warid not exist] playcard",warid,pid,source))
		return
	end
	local warobj = war:getwarobj(pid)
	if warobj.state ~= "init" then
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
end

function CMD.endround(source,warid,pid,request)
	local war = warmgr.getwar(warid)
	if not war then
		logger.log("warning","war",string.format("[warid=%s pid=%s srvname=%s] [warid not exist] endround",warid,pid,source))
		return
	end
	local warobj = war:getwarobj(pid)
	if warobj.state ~= "beginround" then
		return
	end
local roundcnt = assert(request.roundcnt)
	-- endround will call war:s2csync()
	warobj:endround(roundcnt)
end

function CMD.playcard(source,warid,pid,request)
	local war = warmgr.getwar(warid)
	if not war then
		logger.log("warning","war",string.format("[warid=%s pid=%s srvname=%s] [warid not exist] playcard",warid,pid,source))
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
end

function CMD.launchattack(source,warid,pid,request)
	local war = warmgr.getwar(warid)
	if not war then
		logger.log("warning","war",string.format("[warid=%s pid=%s srvname=%s] [warid not exist] playcard",warid,pid,source))
		return
	end
	local warobj = war:getwarobj(pid)
	if warobj.state ~= "beginround" then
		return
	end
local id = assert(request.id)
	local targetid = assert(request.targetid)
	war:s2csync()
end

function CMD.useskill(source,warid,pid,targetid)
	local war = warmgr.getwar(warid)
	if not war then
		logger.log("warning","war",string.format("[warid=%s pid=%s srvname=%s] [warid not exist] useskill",warid,pid,source))
		return
	end
	local warobj = war:getwarobj(pid)
	if warobj.state ~= "beginround" then
		return
	end
	local targetid = request.targetid
	warobj:useskill(targetid)
	war:s2csync()
end

function CMD.lookcards_confirm(source,warid,pid,request)
	local war = warmgr.getwar(warid)
	if not war then
		logger.log("warning","war",string.format("[warid=%s pid=%s srvname=%s] [warid not exist] lookcards_confirm",warid,pid,source))
		return
	end
	local warobj = war:getwarobj(pid)
	if warobj.state ~= "beginround" then
		return
	end
	local pos = assert(request.pos)
	warobj:lookcards_confirm(pos)
	war:s2csync()
end

function CMD.playcard(source,warid,pid,request)
	local war = warmgr.getwar(warid)
	if not war then
		logger.log("warning","war",string.format("[warid=%s pid=%s srvname=%s] [warid not exist] lookcards_confirm",warid,pid,source))
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
end

function CMD.disconnect(source,warid,pid,request)
end

function warsrv.dispatch(source,cmd,...)
	assert(type(source)=="string","Invalid source:" .. tostring(source))
	local func = assert(CMD[cmd],"Unknow cmd:" .. tostring(cmd))
	return func(source,...)
end

return warsrv
