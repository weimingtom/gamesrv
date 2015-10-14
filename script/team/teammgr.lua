cteammgr = class("cteammgr",csaveobj)

function cteammgr:init()
	self.teams = {}
	self.teamid = 0
	self.publish_teams = {}
	-- 内存数据
	self.automatch_pids = {}
	self.automatch_teams = {}
	self:starttimer_check_publishteam()
	self:starttimer_automatch()
	self:autosave()
end

function cteammgr:load(data)
	if not data or not next(data) then
		return
	end
	for i,teamid in ipairs(data.teams) do
		local team = cteam.new(teamid)
		self.teams[teamid] = team
		team:loadfromdatabase()
	end
	local tmp = {}
	for teamid,v in pairs(data.publish_teams) do
		tmp[tonumber(teamid)] = v
	end
	self.publish_teams = tmp
end

function cteammgr:save()
	local data = {}
	data.teams = keys(self.teams)
	local tmp = {}
	for teamid,v in pairs(self.publish_teams) do
		tmp[tostring(teamid)] = v
	end
	data.publish_teams = tmp
end

function cteammgr:loadfromdatabase()
	if self.loadstate == "unload" then
		self.loadstate = "loading"
		local db = dbmgr.getdb()
		local data = db:get(db:key("team","mgr"))
		self:load(data)
		self.loadstate = "loaded"
	end
end

function cteammgr:savetodatabase()
	if self.loadstate == "loaded" then
		local data = self:save()
		local db = dbmgr.getdb()
		db:set(db:key("team","mgr"),data)
	end
end

function cteammgr:genid()
	if self.teamid >= MAX_NUMBER then
		self.teamid = 0
	end
	self.teamid = self.teamid + 1
	return self.teamid
end

function cteammgr:createteam(player,param)
	param = param or {}
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
		return false
	end
	logger.log("info","team",string.format("dismissteam,pid=%d teamid=%d",pid,teamid))
	team:dismissteam()
	self.teams[teamid] = nil
	self:after_dismissteam(player,teamid)
	return true
end

function cteammgr:jointeam(player,teamid)
	assert(player.teamid==nil)
	local pid = player.pid
	local team = self:getteam(teamid)
	if not self:before_jointeam(player,teamid) then
		return false
	end
	logger.log("info","team",string.format("jointeam,pid=%d teamid=%d",pid,teamid))
	team:join(player)
	self:unautomatch(pid,"jointeam")
	self:after_jointeam(player,teamid)
	return true
end

function cteammgr:quitteam(player)
	local teamid = player.teamid
	assert(teamid)
	local pid = player.pid
	local team = self:getteam(teamid)
	if not self:before_quitteam(player,teamid) then
		return false
	end
	logger.log("info","team",string.format("quitteam,pid=%d teamid=%d",pid,teamid))
	team:quit(player)
	self:after_quitteam(player,teamid)
	return true
end

function cteammgr:leaveteam(player)
	local teamid = player.teamid
	assert(teamid)
	local pid = player.pid
	local team = self:getteam(teamid)
	if not self:before_leaveteam(player,teamid) then
		return false
	end
	logger.log("info","team",string.format("leaveteam,pid=%d teamid=%d",pid,teamid))
	team:leave(player)
	self:after_leaveteam(player,teamid)
	return true
end

function cteammgr:backteam(player)
	local teamid = player.teamid
	assert(teamid)
	local pid = player.pid
	local team = self:getteam(teamid)
	if not self:before_backteam(player,teamid) then
		return false
	end
	logger.log("info","team",string.format("backteam,pid=%d teamid=%d",pid,teamid))
	team:back(player)
	self:after_backteam(player,teamid)
	return true
end

function cteammgr:changecaptain(teamid,tid)
	local team = self:getteam(teamid)
	local pid = player.pid
	if not self:before_changecaptain(teamid,tid) then
		return false
	end
	logger.log("info","team",string.format("changecaptain,teamid=%d captain=%d->%d",teamid,team.captain,tid))
	team:changecaptain(tid)
	self:after_changecaptain(teamid,tid)
	return true
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
	local now = os.time()
	teammgr.publish_teams[teamid] = {
		time = now,
		lifecircle = 300,
	}
	local package = {
		teamid = teamid,
		time = now,
		target = publish.target,
		stage = publish.stage,
		captain = player:packmember(),
	}
	broadcast(function (obj)
		if obj.lv > data.limit then
			sendpackage(uid,"team","publishteam",package)
		end
	end)
end

function cteammgr:getpublishteam(teamid)
	local team = self:getteam(teamid)
	local publish
	if team then
		publish = self.publish_teams[teamid]
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
	end
end

function cteammgr:starttimer_check_publishteam()
	timer.timeout("timer.check_publishteam",60,functor(self.starttimer_check_publishteam,self))
	for teamid,publish in pairs(self.publish_team) do
		self:getpublishteam(teamid)
	end
end

function cteammgr:team_automatch(teamid)
	local team = teammgr:getteam(teamid)
	if not team then
		return
	end
	self.automatch_teams[teamid] = {
		time = os.time(),
	}
end

function cteammgr:automatch(player,target,stage)
	local matchdata = self.automatch_pids[pid]
	self.automatch_pids[pid] = {
		time = os.time(),
		name = player.name,
		lv = player.lv,
		roletype = player.roletype,
		target = target,
		stage = stage,
	}
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
	for teamid,v in pairs(self.automatch_teams) do
		local team = teammgr:getteam(teamid)
		if team and team:len(TEAM_STATE_ALL) < team:maxlen() then

			if matchdata.target == 0 or team.target == matchdata.target then
				table.insert(match_teams,teamid)
			end
		end
	end
	if not next(match_teams) then
		return
	end
	table.sort(match_teams,function (teamid1,teamid2)
		local match1 = teammgr.match_teams[teamid1]
		local match2 = teammgr.match_teams[teamid2]
		local team1 = teammgr:getteam(teamid1)
		local team2 = teammgr:getteam(teamid2)
		local len1 = team1:len(TEAM_STATE_ALL)
		local len2 = team2:len(TEAM_STATE_ALL)
		if len1 < len2 then
			return true
		end
		if len1 == len2 and match1.time < match2.time then
			return true
		end
		return false
	end)
	local teamid = match_teams[1]
	teammgr:jointeam(player,teamid)
end

function teammgr:get_automatch_team(teamid)
	local automatch = self.automatch_teams[teamid]
	if not automatch then
		return
	end
	local team = self:getteam(teamid)
	if not team then
		self.automatch_teams[teamid] = nil
		return
	end
	if team:len(TEAM_STATE_ALL) >= team:maxlen() then
		self.automatch_teams[teamid] = nil
		return
	end
	return team
end

function teammgr:starttimer_automatch()
	timer.timeout("timer.automatch",10,functor(self.starttimer_automatch,self))
	local cnt = 0
	for pid,v in pairs(teammgr.automatch_pids) do
		local player = playermgr.getplayer(pid)
		if player then
			cnt = cnt + 1
			teammgr:check_match_team(player)
			if cnt >= 20 then
				break
			end
		end
	end
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

function teammgr:before_changecaptain(teamid,pid)
	return true
end

function teammgr:after_changecaptain(teamid,pid)
end

return teammgr
