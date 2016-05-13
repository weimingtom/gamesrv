require "script.team.init"

cteammgr = class("cteammgr")


function cteammgr.startgame()
	teammgr = cteammgr.new()
	teammgr:starttimer_automatch()
	teammgr:starttimer_check_publishteam()
end

function cteammgr:init()
	self.teams = {}
	self.teamid = 0
	self.publish_teams = {}
	-- 内存数据
	self.automatch_pids = {}
	self.automatch_teams = {}

	self.savename = string.format("cteammgr")
	autosave(self)
end

function cteammgr:clear()
	self.teams = {}
	self.publish_teams = {}
	self.automatch_pids = {}
	self.automatch_teams = {}
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
	if not self.loadstate or self.loadstate == "unload" then
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
	local teamid = player:getteamid()
	if teamid then
		return
	end
	param = param or {}
	local pid = player.pid
	if not self:before_createteam(player,param) then
		return
	end
	teamid = self:genid()
	logger.log("info","team",string.format("[createteam] pid=%d teamid=%d",pid,teamid))
	local team = cteam.new(teamid,{})
	team:create(player,param)
	self.teams[teamid] = team
	self:after_createteam(player,teamid)
	return teamid,team
end

function cteammgr:dismissteam(player)
	local teamid = player:getteamid()
	if not teamid then
		return
	end
	local pid = player.pid
	if not self:before_dismissteam(player,teamid) then
		return false
	end
	logger.log("info","team",string.format("[dismissteam] pid=%d teamid=%d",pid,teamid))

	local team = self:getteam(teamid)
	if not team then
		return
	end
	closesave(team)
	team:dismissteam()
	self.teams[teamid] = nil
	self:after_dismissteam(player,teamid)
	return true
end

function cteammgr:jointeam(player,teamid)
	if player:getteamid() then
		return
	end
	local pid = player.pid
	if not self:before_jointeam(player,teamid) then
		return false
	end
	logger.log("info","team",string.format("[jointeam] pid=%d teamid=%d",pid,teamid))
	local team = self:getteam(teamid)
	team:join(player)
	self:unautomatch(pid,"jointeam")
	self:after_jointeam(player,teamid)
	return true
end

function cteammgr:quitteam(player)
	local teamid = player:getteamid()
	if not teamid then
		return
	end
	local pid = player.pid
	if not self:before_quitteam(player,teamid) then
		return false
	end
	logger.log("info","team",string.format("[quitteam] pid=%d teamid=%d",pid,teamid))
	local team = self:getteam(teamid)
	team:quit(player)
	self:after_quitteam(player,teamid)
	return true
end

function cteammgr:leaveteam(player)
	local teamid = player:getteamid()
	if not teamid then
		return
	end
	local pid = player.pid
	local team = self:getteam(teamid)
	if team.captain == pid then
		return
	end
	if team.leave[pid] then
		return
	end
	if not self:before_leaveteam(player,teamid) then
		return false
	end
	logger.log("info","team",string.format("[leaveteam] pid=%d teamid=%d",pid,teamid))
	team:leaveteam(player)
	self:after_leaveteam(player,teamid)
	return true
end

function cteammgr:backteam(player)
	local teamid = player:getteamid()
	if not teamid then
		return
	end
	local pid = player.pid
	local team = self:getteam(teamid)
	if not team.leave[pid] then
		return
	end
	if not self:before_backteam(player,teamid) then
		return false
	end
	logger.log("info","team",string.format("[backteam] pid=%d teamid=%d",pid,teamid))
	team:back(player)
	self:after_backteam(player,teamid)
	return true
end

function cteammgr:changecaptain(teamid,tid)
	local team = self:getteam(teamid)
	if not self:before_changecaptain(teamid,tid) then
		return false
	end
	logger.log("info","team",string.format("[changecaptain] teamid=%d captain=%d->%d",teamid,team.captain,tid))
	team:changecaptain(tid)
	self:after_changecaptain(teamid,tid)
	return true
end

function cteammgr:publishteam(player,publish)
	local teamid = player:getteamid()
	if not teamid then
		return
	end
	local pid = player.pid
	local team = self:getteam(teamid)
	if team.captain ~= pid then
		return
	end
	logger.log("info","team",format("[publishteam] pid=%d publish=%s",pid,publish))
	team.target = publish.target
	team.stage = publish.stage
	local now = os.time()
	self.publish_teams[teamid] = {
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
	playermgr.broadcast(function (obj)
		sendpackage(obj.pid,"team","publishteam",package)
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
	local publish = self.publish_teams[teamid]
	if publish then
		logger.log("info","team",string.format("[delpublishteam] teamid=%d",teamid))
		self.publish_teams[teamid] = nil
	end
end

function cteammgr:starttimer_check_publishteam()
	timer.timeout("timer.check_publishteam",60,functor(self.starttimer_check_publishteam,self))
	for teamid,publish in pairs(self.publish_teams) do
		self:getpublishteam(teamid)
	end
end

function cteammgr:team_automatch(teamid)
	local team = self:getteam(teamid)
	if not team then
		return
	end
	self.automatch_teams[teamid] = {
		time = os.time(),
	}
end

function cteammgr:automatch(player,target,stage)
	local pid = player.pid
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

function cteammgr:team_unautomatch(teamid,reason)
	local matchdata = self.automatch_teams[teamid]
	if matchdata then
		logger.logger("info","team",string.format("[unautomatch] teamid=%d reason=%s",teamid,reason))
		self.automatch_teams[teamid] = nil
	end
end

function cteammgr:unautomatch(pid,reason)
	local matchdata = self.automatch_pids[pid]
	if matchdata then
		logger.log("info","team",string.format("[unautomatch] pid=%d reason=%s",pid,reason))
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
		local team = self:getteam(teamid)
		if team then
			if team:len(TEAM_STATE_ALL) < team:maxlen() then

				if matchdata.target == 0 or team.target == matchdata.target then
					table.insert(match_teams,teamid)
				end
			end
		else
			self.automatch_teams[teamid] = nil
		end
	end
	if not next(match_teams) then
		return
	end
	table.sort(match_teams,function (teamid1,teamid2)
		local match1 = self.match_teams[teamid1]
		local match2 = self.match_teams[teamid2]
		local team1 = self:getteam(teamid1)
		local team2 = self:getteam(teamid2)
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
	self:jointeam(player,teamid)
end


function cteammgr:starttimer_automatch()
	timer.timeout("timer.automatch",10,functor(self.starttimer_automatch,self))
	local cnt = 0
	for pid,v in pairs(self.automatch_pids) do
		local player = playermgr.getplayer(pid)
		if player then
			cnt = cnt + 1
			self:check_match_team(player)
			if cnt >= 20 then
				break
			end
		end
	end
end

function cteammgr:changetarget(player,target,stage)
	local teamid = player:getteamid()
	if not teamid then
		return
	end
	local team = self:getteam(teamid)
	if team.captain ~= player.pid then
		return
	end
	if target then
		team.target = target
	end
	if stage then
		team.stage = stage
	end
end

function cteammgr:getteam(teamid)
	return self.teams[teamid]
end

function cteammgr:before_createteam(player,param)
	return true
end

function cteammgr:after_createteam(player,teamid)
end

function cteammgr:before_jointeam(player,teamid)
	return true
end

function cteammgr:after_jointeam(player,teamid)
end

function cteammgr:before_leaveteam(player,teamid)
	return true
end

function cteammgr:after_leaveteam(player,teamid)
end

function cteammgr:before_backteam(player,teamid)
	return true
end

function cteammgr:after_backteam(player,teamid)
end

function cteammgr:before_changecaptain(teamid,pid)
	return true
end

function cteammgr:after_changecaptain(teamid,pid)
end

function cteammgr:before_quitteam(player,teamid)
	return true
end

function cteammgr:after_quitteam(player,teamid)
end

return cteammgr
