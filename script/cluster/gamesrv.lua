
require "script.playermgr"

gamesrv = gamesrv or {}

function gamesrv.init()

end

local CMD = {}
-- warsrvmgr --> gamesrv
function CMD.startwar(source,request)
	local pid = assert(request.pid)
	local warid = assert(request.warid)
	local warsrvname = assert(request.warsrvname)
	local enemy = assert(request.enemy)
	local player = playermgr.getplayer(pid)
	if not player then
		player = playermgr.loadofflineplayer(pid)
	end
	player:set("fight.warid",warid)
	player:set("fight.warsrvname",warsrvname)
	sendpackage(pid,"war","matchplayer",enemy)
	sendpackage(pid,"war","startwar",{
		warid = warid,
	})
end

function CMD.endwar(source,request)
	local pid = assert(request.pid)
	local warid = assert(request.warid)
	local result = assert(request.result)
	local stat = request.stat or {}
	local player = playermgr.getplayer(pid)
	if not player then
		return
	end
	local own_warid = player:query("fight.warid")
	local own_warsrvname = player:query("fight.warsrvname")
	assert(own_warid == warid,"Not match warid:" .. tostring(warid))
	player:delete("fight.warid")
	player:delete("fight.warsrvname")
	sendpackage(pid,"war","warresult",{
		warid = warid,
		result = result,
	})
	-- 处理统计信息
end

function gamesrv.dispatch(source,cmd,...)
	assert(type(source)=="string","Invalid source:" .. tostring(source))
	local func = assert(CMD[cmd],"Unknow cmd:" .. tostring(cmd))
	return func(source,...)
end

return gamesrv
