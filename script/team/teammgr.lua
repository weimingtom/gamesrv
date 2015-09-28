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

function cteammgr:createteam(player,target)
	local pid = player.pid
	assert(player.teamid==nil)
	local teamid = self:genid()
	local team = cteam.new(teamid)
	logger.log("info","team",string.format("createteam,pid=%d teamid=%d target=%d",pid,teamid,target))
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
	team.publish = publish
	teammgr.publish_teams[teamid] = true
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
	local teamid = player.teamid
	if teamid then
		local team = self:getteam(teamid)
		if team.captain ~= pid then
			return
		end
		local publish = self.publish_teams[teamid]
		if not publish then
			return
		end
	else
	end
end

return teammgr
