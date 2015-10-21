

netscene = netscene or {}

-- c2s
local REQUEST = {} 
netscene.REQUEST = REQUEST
function REQUEST.move(player,request)
	request.srcpos = request.srcpos or player.pos
	player:move(request)
end

function REQUEST.stop(player,request)
	player:stop()
end

function REQUEST.setpos(player,request)
	player:setpos(request.pos)
end

function REQUEST.enter(player,request)
	player:enterscene(request.sceneid,request.pos)
end

local RESPONSE = {}
netscene.RESPONSE = RESPONSE

-- s2c

return netscene

