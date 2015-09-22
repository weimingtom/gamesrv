cteammgr = class("cteammgr",csaveobj)

function cteammgr:init()
	self.teams = {}
	self.teamid = 0
	self.publish_teams = {}
end

function cteammgr:genid()
	if self.teamid >= MAX_NUMBER then
		self.teamid = 0
	end
	self.teamid = self.teamid + 1
	return self.teamid
end

function cteammgr:createteam(player)
	local pid = player.pid
	assert(player.teamid==nil)
	local teamid = self:genid()
	local team = cteam.new(teamid)
	logger.log("info","team",string.format("createteam,pid=%d teamid=%d",pid,teamid))
	self.teams[teamid] = team
	return teamid,team
end

function cteammgr:dismissteam(player)
	assert(player.teamid)
	local pid = player.pid
	local teamid = player.teamid
	local team = self:getteam(teamid)
	assert(team.captain==pid)
	logger.log("info","team",string.format("dismissteam,pid=%d teamid=%d",pid,teamid))
	team:dismissteam()
	self.teams[teamid] = nil
end

function cteammgr:publishteam(player,publish)
	assert(player.teamid)
	local pid = player.pid
	local teamid = player.teamid
	local team = self:getteam(teamid)
	assert(team.captain==pid)
	logger.log("info","team",format("publishteam,pid=%d publish=%s",pid,publish))
	local now = os.time()
	publish.time = now
	self.publish_teams[teamid] = publish
end

function cteammgr:getpublishteam(teamid)
	local publish = self.publish_teams[teamid]
	if publish and publish.lifecircle and publish.lifecircle + publish.time <= now then
		self:delpublishteam(teamid)
		publish = nil
	end
	return publish
end

function cteammgr:delpublishteam(teamid)
	local publish = self.publish_teams[temaid]
	if publish then
		logger.log("info","team",string.format("delpublishteam,teamid=%d",teamid))
		self.publish_teams[teamid] = nil
	end
end

function cteammgr:automatch(player)
	local pid = player.pid
	local teamid = player:getteamid()
	if teamid then
		local team = self:getteam(teamid)
		if not team then
			return
		end
		if team.captain ~= pid then
			return
		end
		local publish = self.publish_teams[teamid]
		if not publish then
			return
		end
		team.automatch = true
	else
		local matchdata = self.automatch_pids[pid]
		self.automatch_pids[pid] = {
			time = os.time(),
			name = player.name,
			lv = player.lv,
			roletype = player.roletype,
			target = target,
		}
		if not matchdata or matchdata.target ~= target then
			self:check_match_team(player)
		end
	end
end

function cteammgr:unautomatch(pid,reason)
	local matchdata = self.automatch_pids[pid]
	if matchdata then
		logger:logger("info","team",string.format("unautomatch,pid=%d,reason=%s",pid,reason))
		self.automatch_pids[pid] = nil
	end
end

function cteammgr:check_match_team(player)
	local pid = player.pid
	local matchdata = self.automatch_pids[pid]
	if not matchdata then
		return
	end
	local match_teams = {}
	for teamid,publish in pairs(self.publish_team) do
		if matchdata.target == 0 or publish.target == matchdata.target then
			local team = teammgr:getteam(teamid)
			if team and team:len(TEAM_STATE_ALL) < 5 then
				table.insert(match_teams,teamid)
			end
		end
	end
	if not next(match_teams) then
		return
	end
	table.sort(match_teams,function (teamid1,teamid2)
		local publish1 = self.publish_team[teamid1]
		local publish2 = self.publish_team[teamid2]
		local team1 = teammgr:getteam(teamid1)
		local team2 = teammgr:getteam(teamid2)
		local len1 = team1:len(TEAM_STATE_ALL)
		local len2 = team2:len(TEAM_STATE_ALL)
		if len1 < len2 then
			return true
		end
		if len1 == len2 and publish1.time < publish2.time then
			return true
		end
		return false
	end)
	local teamid = match_teams[1]
	local team = teammgr:getteam(teamid)
	team:jointeam(player)
end



return teammgr
