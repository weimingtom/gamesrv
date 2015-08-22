
require "script.playermgr"

gamesrv = gamesrv or {}

function gamesrv.init()

end

local CMD = {}
-- warsrvmgr --> gamesrv
function CMD.startwar(srvname,typ,pid,warsrvname,warid,matcher_profile)
	--pprintf("%s %s %s %s %s %s",srvname,typ,pid,warsrvname,warid,matcher_profile)
	local player = playermgr.getplayer(pid)
	if not player then
		return
	end
	if typ == "fight" then
		player:set("fight.warid",warid)
		player:set("fight.warsrvname",warsrvname)
		sendpackage(pid,"war","matchplayer",matcher_profile)
		sendpackage(pid,"war","startwar",{
			warid = warid,
		})
	end
end

function CMD.endwar(srvname,typ,pid,warsrvname,warid,result,profile,lastmatch)
	local player = playermgr.getplayer(pid)
	if not player then
		return
	end
	if typ == "fight" then
		local own_warid = player:query("fight.warid")
		local own_warsrvname = player:query("fight.warsrvname")
		assert(own_warid == warid,"Not match warid:" .. tostring(warid))
		assert(own_warsrvname == warsrvname,"Not match warsrvname:" .. tostring(warsrvname))
		player:delete("fight.warid")
		player:delete("fight.warsrvname")
		player:unpack_fight_profile(profile)
		sendpackage(pid,"war","warresult",{
			warid = warid,
			result = result,
		})
	end
end

function gamesrv.dispatch(srvname,cmd,...)
	assert(type(srvname)=="string","Invalid srvname:" .. tostring(srvname))
	local func = assert(CMD[cmd],"Unknow cmd:" .. tostring(cmd))
	return func(srvname,...)
end

return gamesrv
