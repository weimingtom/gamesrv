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
