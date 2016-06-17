service = service or {}

local scene = {}
function scene.leave(pid)
	local player = playermgr.getplayer(pid)
	if player then
		player.sceneid = nil		
		player.pos = nil
		player:enterscene(DEFAULT_SCENEID,DEFAULT_POS)
	end
end

service.scene = scene

function service.dispatch(session,source,protoname,cmd,...)

	local tbl = service[protoname]
	local func = tbl[cmd]
	return func(...)
end

return service
