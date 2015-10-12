

netteam = netteam or {}

-- c2s
local REQUEST = {} 
netteam.REQUEST = REQUEST

function REQUEST.createteam(player,request)
	local teamid = player:getteamid()
	if teamid then
		return
	end
	teammgr:createteam(player,request)
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
	teammgr:jointeam(player,teamid)
end

function REQUEST.quitteam(player,request)
	local teamid = player:getteamid()
	if not teamid then
		return
	end
	teammgr:quitteam(player,teamid)
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
			net.msg.messgebox(uid,
				MB_RECALLMEMBER,
				"召回",
				string.format("队长#<red>%s#(等级:%d级)召回你归队",player.name,player.lv),
				{},
				{"确认","取消",},
				function (obj,request,buttonid)
					if buttonid ~= 1 then
						return
					end
					if target.teamid ~= teamid then
						return
					end
					local team = teammgr:getteam(teamid)	
					if not team then
						return
					end
					if not team.leave[obj.pid] then
						return
					end
					team:backteam(obj)
				end)
		end
	end
end

function REQUEST.apply_become_captain(player,request)
	local teamid = player:getteamid()
	if not teamid then
		return
	end
	local team = teammgr:getteam(teamid)
	if not team then
		return
	end
	local pid = player.pid
	if team.captain == pid then
		return
	end
	if team.leave[pid] then
		return
	end
	net.msg.messagebox(team.captain,
		MB_APPLY_BECOME_CAPTAIN,
		"申请队长",
		string.format("队员#<red>%s#(等级:%d级)申请成为队长",player.name,player.lv),
		{},
		{"同意","拒绝"},
		function (obj,request,buttonid)
			if not buttonid ~= 1 then
				return
			end
			if obj.teamid ~= teamid then
				return
			end
			local team = teammgr:gettam(teamid)
			if not team then
				return
			end
			if not team.follow[obj.pid] then
				return
			end
			team:changecaptain(obj.pid)
		end)
end

function REQUEST.changecaptain(player,request)
	local pid = request.pid
	local teamid = player:getteamid()
	if not teamid then
		return
	end
	local team = teammgr:getteam(teamid)
	if not team then
		return team
	end
	if team.captain ~= player.pid then
		return
	end
	if not team.follow[pid] then
		return
	end
	team:changecaptain(pid)
end

function REQUEST.invite_jointeam(player,request)
	local pid = request.pid
	local teamid = player:getteamid()
	if not teamid then
		return
	end
	local team = teammgr:getteam(teamid)
	if not team then
		return
	end
	if team:ismember(pid) then
		return
	end
	net.msg.messagebox(pid,
		MB_INVITE_JOINTEAM,
		"邀请入队",
		string.format("#<red>%s#(等级:%d级)邀请你加入他的队伍",player.name,player.lv),
		{},
		{"同意","拒绝"},
		function (obj,request,buttonid)
			if buttonid ~= 1 then
				return
			end
			local team = teammgr:getteam(teamid)
			if not team then
				return
			end
			if team:ismember(obj.pid) then
				return
			end
			team:addapplyer(obj)
		end)
end

function REQUEST.syncteam(player,request)
	local teamid = request.teamid
	local team = teammgr:getteam(teamid)
	local package = {}
	if team then
		package = team:pack()
	end
	sendpackage(player.pid,"team","syncteam",package)
end

function REQUEST.openui_team(player,request)
	local teams = {}
	for teamid,team in pairs(self.teams) do
		table.insert(teams,team:pack())
	end
	return teams
end

local RESPONSE = {}
netteam.RESPONSE = RESPONSE
function RESPONSE.handshake(player,request,response)
end

function RESPONSE.get(player,request,response)
end

-- s2c
return netteam
