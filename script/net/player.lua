
require "script.gm"

netplayer = netplayer or {}
-- c2s
local REQUEST = {}
netplayer.REQUEST = REQUEST

function REQUEST.gm(player,request)
	local cmd = assert(request.cmd)
	return gm.docmd(player.pid,cmd)
end

local validarea = {"arena","fight","entertainment","fuben","practice",}
local validarea = {
	arena = true,
	fight = true,
	entertainment = true,
	fuben = true,
	practice = true,
	opencard = true,
}
function REQUEST.enter(player,request)
	local what = assert(request.what)
	assert(validarea[what],"Invalid area:" .. tostring(what))
	return player:doing(what)
end

local RESPONSE = {}
netplayer.RESPONSE = RESPONSE

return netplayer


