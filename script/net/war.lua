
local function callwar(player,cmd,request)
	local warsrvname = assert(player:query("fight.warsrvname"))
	local warid = assert(player:query("fight.warid"))
	local pid = player.pid
	request.warid = warid
	request.pid = pid
	return cluster.call(warsrvname,"war",cmd,request)
end

netwar = netwar or {}

-- c2s
local REQUEST = {} 
netwar.REQUEST = REQUEST

-- forward to warsrvmgr
function REQUEST.selectcardtable(player,request)
	local cardtableid = assert(request.cardtableid)
	local type = assert(request.type)

	if type == "fight" then
		player:set("fight.cardtableid",cardtableid)

	end
end

function REQUEST.search_opponent(player,request)
	local type = assert(request.type)
	if type == "fight" then
		local profile = player:pack_fight_profile(type)
		return cluster.call("warsrvmgr","war","search_opponent",profile)
	end
end

function REQUEST.unsearch_opponent(player,request)
	return cluster.call("warsrvmgr","war","unsearch_opponent",player.pid)
end

-- forward
-- gamesrv -> warsrv
function REQUEST.confirm_handcard(player,request)
	return callwar(player,"confirm_handcard",request)
end

function REQUEST.playcard(player,request)
	return callwar(player,"playcard",request)
end

function REQUEST.endround(player,request)
	return callwar(player,"endround",request)
end

function REQUEST.launchattack(player,request)
	return callwar(player,"launchattack",request)
end

function REQUEST.useskill(player,request)
	return callwar(player,"useskill",request)
end

function REQUEST.giveupwar(player,request)
	return callwar(player,"giveupwar",request)
end

function REQUEST.lookcards_confirm(player,request)
	return callwar(player,"lookcards_confirm",request)
end

function REQUEST.playcard(player,request)
	return callwar(player,"playcard",request)
end

local RESPONSE = {}
netwar.RESPONSE = RESPONSE

-- s2c
return netwar
