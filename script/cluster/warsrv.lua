
require "script.war.init"
require "script.war.warmgr"

warsrv = warsrv or {}

function warsrv.init()
	warmgr.init()
end

local CMD = {}
-- warsrvmgr --> warsrv
function CMD.createwar(srvname,profile1,profile2)
	assert(srvname == "warsrvmgr","Invalid srvname:" .. srvname)
	if warmgr.num > 100000 then
		return false
	end
	local war = warmgr.createwar(profile1,profile2)
	warmgr.addwar(war)
	cluster.call(srvname,"war","startwar",profile1.pid,war.warid)
	cluster.call(srvname,"war","startwar",profile2.pid,war.warid)
	war:startwar()
	war:s2csync()
	return true
end

function CMD.query_profile(srvname)
	assert(srvname == "warsrvmgr","Invalid srvname:" .. srvname)
	local profile = {
		num = warmgr.num,
	}
	return profile
end

function CMD.endwar(srvname,pid,warid)
	assert(srvname == "warsrvmgr","Invalid srvname:" .. srvname)
	local war = warmgr.getwar(warid)
	if not war then
		logger.log("warning","war",string.format("#%d endwar(warid not exists),srvname=%d warid=%d",pid,srvname,warid))
		return
	end
	warmgr.endwar(warid,2,2)
end

-- gamesrv --> warsrv
function CMD.giveupwar(srvname,pid,warid)
	local war = warmgr.getwar(warid)
	if not war then
		logger.log("warning","war",string.format("#%d giveupwar(warid not exists),srvname=%d warid=%d",pid,srvname,warid))
		return
	end
	local warobj = war:getwarobj(pid)
	warmgr.endwar(warid,0,1)
end

function CMD.confirm_handcard(srvname,pid,warid,poslist)
	local war = warmgr.getwar(warid)
	if not war then
		logger.log("warning","war",string.format("#%d confirm_handcard(warid not exists),srvname=%s warid=%d",pid,srvname,warid))
		return
	end
	local warobj = war:getwarobj(pid)
	warobj:confirm_handcard(poslist)
	if warobj.enemy.state == "confirm_handcard" then
		if warobj.type == "attacker" then
			warobj:beginround()
		else
			warobj.enemy:beginround()
		end
		war:s2csync()
	end
end

function CMD.endround(srvname,pid,warid,roundcnt)
	local war = warmgr.getwar(warid)
	if not war then
		logger.log("warning","war",string.format("#%d endround(warid not exists),srvname=%d warid=%d",pid,srvname,warid))
		return
	end
	local warobj = war:getwarobj(pid)
	if warobj.state ~= "beginround" then
		return
	end
	-- endround will call war:s2csync()
	warobj:endround(roundcnt)
end

function CMD.playcard(srvname,pid,warid,warcardid,pos,targetid,choice)
	local war = warmgr.getwar(warid)
	if not war then
		logger.log("warning","war",string.format("#%d playcard(warid not exists),srvname=%d warid=%d",pid,srvname,warid))
		return
	end
	local warobj = war:getwarobj(pid)
	if warobj.state ~= "beginround" then
		return
	end
	warobj:playcard(warcardid,pos,targetid,choice)
	war:s2csync()
end

function CMD.launchattack(srvname,pid,warid,attackerid,targetid)
	local war = warmgr.getwar(warid)
	if not war then
		logger.log("warning","war",string.format("#%d playcard(warid not exists),srvname=%d warid=%d",pid,srvname,warid))
		return
	end
	local warobj = war:getwarobj(pid)
	if warobj.state ~= "beginround" then
		return
	end
	warobj:launchattack(attackerid,targetid)
	war:s2csync()
end

function CMD.hero_useskill(srvname,pid,warid,targetid)
	local war = warmgr.getwar(warid)
	if not war then
		logger.log("warning","war",string.format("#%d playcard(warid not exists),srvname=%d warid=%d",pid,srvname,warid))
		return
	end
	local warobj = war:getwarobj(pid)
	if warobj.state ~= "beginround" then
		return
	end
	warobj:hero_useskill(targetid)
	war:s2csync()
end

function CMD.lookcards_confirm(srvname,pid,warid,pos)
	local war = warmgr.getwar(warid)
	if not war then
		logger.log("warning","war",string.format("#%d playcard(warid not exists),srvname=%d warid=%d",pid,srvname,warid))
		return
	end
	local warobj = war:getwarobj(pid)
	if warobj.state ~= "beginround" then
		return
	end
	warobj:lookcards_confirm(pos)
	war:s2csync()
end

function CMD.disconnect(srvname,pid,warid)
end

function warsrv.dispatch(srvname,cmd,...)
	assert(type(srvname)=="string","Invalid srvname:" .. tostring(srvname))
	local func = assert(CMD[cmd],"Unknow cmd:" .. tostring(cmd))
	return func(srvname,...)
end

return warsrv
