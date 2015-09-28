

netteam = netteam or {}

-- c2s
local REQUEST = {} 
netteam.REQUEST = REQUEST

function REQUEST.createteam(player,request)
	local teamid = player:getteamid()
	if teamid then
		return
	end
	teammgr:createteam(player)
end

function REQUEST.dismissteam(player,request)
	local teamid = player:getteamid()
	if not teamid then
		return
	end
	teammgr:dismissteam(player)
end

function REQUEST.jointeam(player,request)
	local teamid = player:getteamid()
	if teamid then
		return
	end
	local teamid = request.teamid
	local team = teammgr:getteam(teamid)
	if not team then
		return
	end
	team:jointeam(player)
end

function REQUEST.publishsteam(player,request)
	local teamid = player:getteamid()
	if not teamid then
		return
	end
	local team = teammgr:getteam(teamid)
	if not team then
		return
	end
	local pid = player.pid
	if team.captain ~= pid then
		return
	end
	teammgr:publishteam(player,request)
end

function REQUEST.leaveteam(player,request)
	local pid = player.pid
	local teamid = player:getteamid()
	if not teamid then
		return
	end
	local team = teammgr:getteam(teamid)
	if not team then
		return
	end
	if team.captain == pid then
		return
	end
	if team.leave[pid] then
		return
	end
	team:leaveteam(player)
end

function REQUEST.quitteam(player,request)
	local teamid = player:getteamid()
	if not teamid then
		return
	end
	local team = teammgr:getteam(teamid)
	if not team then
		return
	end
	team:quitteam(player)
end

function REQUEST.backteam(player,request)
	local pid = player.pid
	local teamid = player:getteamid()
	if not teamid then
		return
	end
	local team = teammgr:getteam(teamid)
	if not team then
		return
	end
	if not team.leave[pid] then
		return
	end
	team:backteam(player)
end

function REQUEST.recallmember(player,request)
	local teamid = player:getteamid()
	if not teamid then
		return
	end
	local team = teammgr:getteam(teamid)
	if not team then
		return
	end
	local pid = player.pid
	if team.captain ~= pid then
		return
	end
	local pids = request.pids
	for i,uid in ipairs(pids) do
		if uid ~= pid and team:ismember(uid) then
			net.msg.messgebox(uid,MB_RECALLMEMBER,"召回",string.format("队长#<red>%s#(等级:%d级)召回你归队",player.name,player.lv),{"确认","取消",},function (target,request,buttonid)
				if buttonid ~= MB_BUTTON_YES then
					return
				end
				local team = teammgr:getteam(teamid)	
				if not team then
					return
				end
				team:backteam(player)
			end)
		end
	end
end

local RESPONSE = {}
netteam.RESPONSE = RESPONSE
function RESPONSE.handshake(player,request,response)
end

function RESPONSE.get(player,request,response)
end

-- s2c
return netteam
