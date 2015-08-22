

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
		--local warid = player:query("fight.warid")
		--if warid then
		--	logger.log("warning","war",string.format("%d search_opponet,but aready in war,warid=%d",player.pid,warid))
		--	return
		--end
		local profile = player:pack_fight_profile()	
		return cluster.call("warsrvmgr","war","search_opponent",profile)
	end
end

-- forward to warsrv
function REQUEST.confirm_handcard(player,request)
	local poslist = assert(request.poslist)
	local warsrvname = assert(player:query("fight.warsrvname"))
	local warid = assert(player:query("fight.warid"))
	return cluster.call(warsrvname,"war","confirm_handcard",player.pid,warid,poslist)	
end

function REQUEST.playcard(player,request)
	local cardid = assert(request.cardid)
	local pos = request.pos
	local targetid = request.targetid
	local choice = request.choice
	local warsrvname = assert(player:query("fight.warsrvname"))
	local warid = assert(player:query("fight.warid")) 
	return cluster.call(warsrvname,"war","playcard",player.pid,warid,cardid,pos,targetid,choice)
end

function REQUEST.endround(player,request)
	local roundcnt = request.roundcnt
	local warsrvname = assert(player:query("fight.warsrvname"))
	local warid = assert(player:query("fight.warid")) 
	return cluster.call(warsrvname,"war","endround",player.pid,warid,roundcnt)
end

function REQUEST.launchattack(player,request)
	local attackerid = assert(request.attackerid)
	local defenserid = assert(request.defenserid)
	local warsrvname = assert(player:query("fight.warsrvname"))
	local warid = assert(player:query("fight.warid")) 
	return cluster.call(warsrvname,"war","launchattack",player.pid,warid,attackerid,defenserid)
end

function REQUEST.hero_useskill(player,request)
	local targetid = assert(request.targetid)
	local warsrvname = assert(player:query("fight.warsrvname"))
	local warid = assert(player:query("fight.warid")) 
	return cluster.call(warsrvname,"war","launchattack",player.pid,warid,targetid)
end

function REQUEST.giveupwar(player,request)
	local warid = assert(player:query("fight.warid"))
	local warsrvname = assert(player:query("fight.warsrvname"))
	return cluster.call(warsrvname,"war","giveupwar",player.pid,warid)
end

function REQUEST.lookcards_confirm(player,request)
	local pos = assert(request.pos)
	local warid = assert(player:query("fight.warid"))
	local warsrvname = assert(player:query("fight.warsrvname"))
	return cluster.call(warsrvname,"war","lookcards_confirm",player.pid,warid,pos)
end

local RESPONSE = {}
netwar.RESPONSE = RESPONSE

-- s2c
return netwar
