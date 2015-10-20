

netteam = netteam or {}

-- c2s
local REQUEST = {} 
netteam.REQUEST = REQUEST

function REQUEST.createteam(player,request)
	teammgr:createteam(player,request)
end

function REQUEST.dismissteam(player,request)
	teammgr:dismissteam(player)
end

function REQUEST.jointeam(player,request)
	local teamid = request.teamid
	teammgr:jointeam(player,teamid)
end

function REQUEST.quitteam(player,request)
	teammgr:quitteam(player)
end

function REQUEST.publishsteam(player,request)
	teammgr:publishteam(player,request)
end

function REQUEST.leaveteam(player,request)
	teammgr:leaveteam(player)
end



function REQUEST.backteam(player,request)
	teammgr:backteam(player)
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
	if not team.follow[pid] then
		return
	end
	local captain = playermgr.getplayer(team.captain)
	if not captain then
		teammgr:changecaptain(teamid,player.pid)
	else
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
				if team.captain == obj.pid then
					return
				end
				if not team.follow[obj.pid] then
					return
				end
				teammgr:changecaptain(teamid,obj.pid)
			end)
	end

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
	teammgr:changecaptain(teamid,pid)
end

function REQUEST.invite_jointeam(player,request)
	local pid = player.pid
	local tid = request.pid
	local teamid = player:getteamid()
	if not teamid then
		teamid = teammgr:createteam(player,{})
	end
	local team = teammgr:getteam(teamid)
	if not team then
		return
	end
	if team:ismember(tid) then
		return
	end
	net.msg.messagebox(tid,
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
			if team.captain == pid then
				teammgr:jointeam(obj,teamid)
			else
				team:addapplyer(obj)
			end
		end)
end

function REQUEST.syncteam(player,request)
	local teamid = request.teamid
	local team = teammgr:getteam(teamid)	
	local package
	if not team then
		package = {}
	else
		package = team:pack()
	end
	sendpackage(player.pid,"team","syncteam",{
		team = package,
	})
end

function REQUEST.openui_team(player,request)
	local pid = player.pid
	local teamid = player:getteamid()
	if not teamid then
		local teams = {}
		for teamid,team in pairs(teammgr.teams) do
			table.insert(teams,team:pack())
		end
		sendpackage(pid,"team","openui_team",{
			teams = teams,
			automatch = teammgr.automatch_pids[pid] and true or false,
		})
	else
		local team = teammgr:getteam(teamid)
		if team then
			sendpackage(player.pid,"team","syncteam",{
				team = team:pack(),
			})
		end
	end
end

function REQUEST.automatch(player,request)
	local target = request.target
	local stage = request.stage
	local teamid = player:getteamid()
	if not teamid then
		teammgr:automatch(player,target,stage)
	else
		local team = teammgr:getteam(teamid)
		if team.captain ~= player.pid then
			return
		end
		teammgr:team_automatch(teamid)
	end
end

function REQUEST.unautomatch(player,request)
	local teamid = player:getteamid()
	if not teamid then
		teammgr:unautomatch(player.pid,"cacel")
	else
		local team = teammgr:getteam(teamid)
		if team.captain ~= player.pid then
			return
		end
		teammgr:team_unautomatch(teamid,"cacel")
	end
end

function REQUEST.changetarget(player,request)
	local target = request.target
	local stage = request.stage
	teammgr:changetarget(player,target,stage)
end

function REQUEST.apply_jointeam(player,request)
	local teamid = player:getteamid()
	if teamid then
		return
	end
	local teamid = request.teamid
	local team = teammgr:getteam(teamid)
	if not team then
		return
	end
	team:addapplyer(player)
end

function REQUEST.delapplyers(player,request)
	local pids = request.pids
	local teamid = player:getteamid()
	if not teamid then
		return
	end
	local team = teammgr:getteam(teamid)
	if team.captain ~= player.pid then
		return
	end
	if pids then
		for i,pid in ipairs(pids) do
			team:delapplyer(pid)
		end
	else
		team:clearapplyer()
	end
end

function REQUEST.agree_jointeam(player,request)
	local pid = request.pid
	local teamid = player:getteamid()
	if not teamid then
		return
	end
	local team = teammgr:getteam(teamid)
	if team.captain ~= player.pid then
		return
	end
	local applyer = team:getapplyer(pid)
	if not applyer then
		return
	end
	local target = playermgr.getplayer(pid)
	if not target then
		net.msg.notify(player,"对方已离线")
		return
	end
	if target:getteamid() then
		net.msg.notify(player,"对方已经有队伍了")
		return
	end
	teammgr:jointeam(target,teamid)
end

local RESPONSE = {}
netteam.RESPONSE = RESPONSE

-- s2c
return netteam
