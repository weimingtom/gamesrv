service = service or {}

local scene = {}
function scene.quit(pid)
	local player = playermgr.getplayer(pid)
	if player then
		player.sceneid = nil		
		player.pos = nil
		player:enter(DEFAULT_SCENEID,DEFAULT_POS)
	end
end

service.scene = scene

function service.dispatch(session,source,protoname,cmd,...)
	local tbl = service[protoname]	
	local func = tbl[cmd]
	func(...)
end

return service
