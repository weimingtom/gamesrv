local cplayer = require "script.player"

function cplayer:player_lv()
	return self.lv
end

function cplayer:player_org_lv()
	return 0
end

function cplayer:player_team_maxlv(state)
	state = state or TEAM_STATE_ALL 
	local teamid = self:getteamid()
	if not teamid then
		return self.lv
	else
		local team = teammgr:getteam(teamid)
		local maxlv = 0
		for i,uid in ipairs(team:members(state)) do
			local member = playermgr.getplayer(uid)
			if member.maxlv > maxlv then
				maxlv = member.maxlv
			end
		end
		return maxlv
	end
end

function cplayer:player_team_avglv(state)
	state = state or TEAM_STATE_ALL
	local teamid = self:getteamid()
	if not teamid then
		return self.lv
	else
		local team = teammgr:getteam(teamid)
		local sumlv = 0
		local cnt = 0
		for i,uid in ipairs(team:members(state)) do
			local member = playermgr.getplayer(uid)
			cnt = cnt + 1
			sumlv = sumlv + member.lv
		end
		return math.floor(sumlv / cnt)
	end
end

function cplayer:player_team_avglv2(state)
	state = state or TEAM_STATE_ALL
	local maxlv = self:player_team_maxlv(state)
	local avglv = self:player_team_avglv(state)
	return math.floor((maxlv+avglv)/2)
end

function cplayer:player_captain_lv()
	local teamid = self:getteamid()
	if not teamid then
		return self.lv
	else
		local team = teammgr:getteam(teamid)
		local captain = playermgr.getplayer(team.captain)
		return captain.lv
	end
end

function cplayer:player_shimen_circle()
	return self.taskdb.circle.shimen or 0
end
