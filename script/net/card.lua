

netcard = netcard or {}

-- c2s
local REQUEST = {} 
netcard.REQUEST = REQUEST
function REQUEST.updatecardtable(player,request)
	return player.cardtablelib:updatecardtable(request)
end

function REQUEST.delcardtable(player,request)
	local id = assert(request.id)
	local mode = assert(request.mode)
	return player.cardtablelib:delcardtable(id,mode)
end

local RESPONSE = {}

-- s2c

return netcard
