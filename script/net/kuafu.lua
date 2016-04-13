netkuafu = netkuafu or {}

-- c2s
local REQUEST = {} 
netkuafu.REQUEST = REQUEST

function REQUEST.gosrv(player,request)
	local go_srvname = request.go_srvname
	local now_srvname = cserver.getsrvname()
	if now_srvname == go_srvname then
		return
	end
	if not srvlist[go_srvname] then
		return
	end
	if not cserver.isgamesrv(go_srvname) then
		return
	end
	playermgr.gosrv(player,go_srvname)
end

function REQUEST.gohome(player,request)
	local home_srvname = player.home_srvname
	if not home_srvname then
		return
	end
	playermgr.gohome(player)
end

local RESPONSE = {}
netkuafu.RESPONSE = RESPONSE

return netkuafu
