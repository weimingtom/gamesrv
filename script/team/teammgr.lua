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

function cteammgr:createteam(player,param)
	local pid = player.pid
	assert(player.teamid==nil)
	if not self:before_createteam(player,param) then
		return
	end
	local teamid = self:genid()
	logger.log("info","team",string.format("createteam,pid=%d teamid=%d",pid,teamid))
	local team = cteam.new(teamid,{})
	team:create(param)
	self.teams[teamid] = team
	self:after_createteam(player,teamid)
	return teamid,team
end

function cteammgr:dismissteam(player)
	assert(player.teamid)
	local pid = player.pid
	local teamid = player.teamid
	local team = self:getteam(teamid)
	assert(team.captain==pid)
	if not self:before_dismissteam(player,teamid) then
		return
	end
	logger.log("info","team",string.format("dismissteam,pid=%d teamid=%d",pid,teamid))
	team:dismissteam()
	self.teams[teamid] = nil
	self:after_dismissteam(player,teamid)
end

function cteammgr:jointeam(player,teamid)
	assert(player.teamid==nil)
	local pid = player.pid
	local team = self:getteam(teamid)
	if not self:before_jointeam(player,teamid) then
		return
	end
	logger.log("info","team",string.format("jointeam,pid=%d teamid=%d",pid,teamid))
	team:join(player)
	self:unautomatch(pid,"jointeam")
	self:after_jointeam(player,teamid)
end

function cteammgr:quitteam(player)
	local teamid = player.teamid
	assert(teamid)
	local pid = player.pid
	local team = self:getteam(teamid)
	if not self:before_quitteam(player,teamid) then
		return
	end
	logger.log("info","team",string.format("quitteam,pid=%d teamid=%d",pid,teamid))
	team:quit(player)
	self:after_quitteam(player,teamid)
end

function cteammgr:leaveteam(player)
	local teamid = player.teamid
	assert(teamid)
	local pid = player.pid
	local team = self:getteam(teamid)
	if not self:before_leaveteam(player,teamid) then
		return
	end
	logger.log("info","team",string.format("leaveteam,pid=%d teamid=%d",pid,teamid))
	team:leave(player)
	self:after_leaveteam(player,teamid)
end

function cteammgr:backteam(player)
	local teamid = player.teamid
	assert(teamid)
	local pid = player.pid
	local team = self:getteam(teamid)
	if not self:before_backteam(player,teamid) then
		return
	end
	logger.log("info","team",string.format("backteam,pid=%d teamid=%d",pid,teamid))
	team:back(player)
	self:after_backteam(player,teamid)
end

function cteammgr:changecaptain(player,tid)
	local teamid = player.teamid
	assert(teamid)
	local team = self:getteam(teamid)
	local pid = player.pid
	assert(team.captain == pid)
	if not self:before_changecaptain(player,tid) then
		return
	end
	logger.log("info","team",string.format("changecaptain,teamid=%d captain=%d->%d",teamid,pid,tid))
	team:changecaptain(tid)
	self:after_changecaptain(player,tid)
end

function cteammgr:publishteam(player,publish)
	assert(player.teamid)
	local pid = player.pid
	local teamid = player.teamid
	local team = self:getteam(teamid)
	assert(team.captain==pid)
	logger.log("info","team",format("publishteam,pid=%d publish=%s",pid,publish))
	team.target = publish.target
	team.stage = publish.stage
	teammgr.publish_teams[teamid] = {
		time = os.time(),
	}
	local package = {
		target = 
	}
	broadcast(function (obj)
		if obj.lv > data.limit then
			sendpackage(uid,"team","publishteam",)
		end
	end)
end

function cteammgr:getpublishteam(teamid)
	local team = self:getteam(teamid)
	local publish
	if team then
		publish = team.publish
		if publish and publish.lifecircle and publish.lifecircle + publish.time <= now then
			self:delpublishteam(teamid)
		end
	end
	return publish
end

function cteammgr:delpublishteam(teamid)
	local publish = self.publish_teams[temaid]
	if publish then
		logger.log("info","team",string.format("delpublishteam,teamid=%d",teamid))
		self.publish_teams[teamid] = nil
		local team = self:getteam(teamid)
		if team then
			team.publish = false
		end
	end
end

function cteammgr:team_automatch(teamid)
	local team = teammgr:getteam(teami)
	if team and team.publish then
		team.publish.automatch = true
	end
end

function cteammgr:automatch(player)
	
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

function teammgr:before_createteam(player,param)
	return true
end

function teammgr:after_createteam(player,teamid)
end

function teammmgr:before_jointeam(player,teamid)
	return true
end

function teammmgr:after_jointeam(player,teamid)
end

function teammgr:before_leaveteam(player,teamid)
	return true
end

function teammgr:after_leaveteam(player,teamid)
end

function teammgr:before_backteam(player,teamid)
	return true
end

function teammgr:after_backteam(player,teamid)
end

return teammgr
