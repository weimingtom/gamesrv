cteam = class("cteam")

function cteam:init(teamid,param)
	self.teamid = teamid
	self.follow = {}
	self.leave = {}
	self.captain = 0
	self.applyers = {}
	self.target = param.target or 0
	self.stage = param.stage or 0
end

function cteam:load(data)
	if not data or not next(data) then
		return
	end
	local tmp = {}
	for pid,v in pairs(data.follow) do
		pid = tonumber(pid)
		tmp[pid] = v
	end
	self.follow = tmp
	tmp = {}
	for pid,v in pairs(data.leave) do
		pid = tonumber(pid)
		tmp[pid] = v
	end
	self.leave = tmp
	self.captain = data.pid
	tmp = {}
	for pid,applyer in pairs(data.applyers) do
		pid = tonumber(pid)
		tmp[pid] = applyer
	end
	self.applyers = tmp
end

function cteam:save()
	local data = {}
	local tmp = {}
	for pid,v in pairs(self.follow) do
		tmp[tostring(pid)]=v
	end
	data.follow = tmp
	tmp = {}
	for pid,v in pairs(self.leave) do
		tmp[tostring(pid)]=v
	end
	data.leave = tmp
	data.captain = self.captain
	tmp = {}
	for pid,applyer in pairs(self.applyers) do
		tmp[tostring(pid)] = applyer
	end
	data.applyers = tmp
	return data
end

function cteam:onlogin(player)
	local pid = player.pid
	sendpackage(pid,"team","addapplyer",self.applyers)
end

function cteam:onlogoff(player)
end

function cteam:create(player,param)
	local pid = player.pid
	self.target = param.target or 0
	self.stage = param.stage or 0
	self.captain = pid
	local scene = scenemgr.getscene(player.sceneid)
	local state = player:teamstate()
	scene:sync(pid,{
		teamid = self.teamid,
		state = state,
	})
	self:broadcast(function (uid)
		sendpackage(uid,"team","selfteam",{
			team = self:pack(),
		})
	end)
end

function cteam:join(player)
	local teamid = player.teamid
	assert(teamid==nil)
	local pid = player.pid
	player.teamid = self.teamid
	self.leave[pid] = true
	local scene = scenemgr.getscene(player.sceneid)
	local state = player:teamstate()
	scene:sync(pid,{
		teamid = self.teamid,
		state = state,
	})
	
	self:broadcast(function (uid)
		if uid ~= pid then
			sendpackage(uid,"team","addmember",{
				teamid = self.teamid,
				member = self:packmember(player),
			})
		end
	end)
	sendpackage(pid,"team","selfteam",{
		team = self:pack(),
	})
end

function cteam:back(player)
	local pid = player.pid
	local captain = playermgr.getplayer(self.captain)
	local scene = scenemgr.getscene(captain.sceneid)
	if self.leave[pid] then
		self.leave[pid] = nil
	end
	self.follow[pid] = true
	local state = player:teamstate()
	-- TODO: modify
	scene:sync(pid,{
		sceneid = captain.sceneid,
		x = captian.x,
		y = captain.y,
		dir = captain.dir,
		teamid = self.teamid,
		state = state,
	})
	self:broadcast(function (uid)
		sendpackage(uid,"team","updatemember",{
			teamid = self.teamid,
			member = {
				pid = pid,
				state = state,
			}
		})
	end)
end

function cteam:leave(player)
	local pid = player.pid
	assert(self.captain ~= pid)
	self.follow[pid] = nil
	self.leave[pid] = true
	local scene = scenemgr.getscene(player.sceneid)
	local state = player:teamstate()
	scene:sync(pid,{
		teamid = self.teamid,
		state = state,
	})
	self:broadcast(function (uid)
		sendpackage(uid,"team","updatemember",{
			teamid = self.teamid,
			member = {
				pid = pid,
				state = state,
			}
		})
	end)
	return true
end

function cteam:choose_newcaptain()
	local newcaptain
	if next(self.follow) then
		newcaptain = randlist(keys(self.follow))
	elseif next(self.leave) then
		newcaptain = randlist(keys(self.leave))
	end
	return newcaptain
end

function cteam:quit(player)
	local pid = player.pid
	local oldcaptain = self.captain
	if oldcaptain == pid then
		local newcaptain = self:choose_newcaptain()
		if newcaptain then
			teammgr:changecaptain(player.teamid,newcaptain)
		else
			self.captain = nil
		end
	end
	player.teamid = nil
	self.follow[pid] = nil
	self.leave[pid] = nil
	local scene = scenemgr.getscene(player.sceneid)
	local state = player:teamstate() -- NO_TEAM
	scene:sync(pid,{
		teamid = 0,
		state = state,
	})
	self:broadcast(function (uid)
		sendpackage(uid,"team","quitteam",{
			teamid = self.teamid,
			pid = oldcaptain,
		})
		if self.captain then
			sendpackage(uid,"team","updatemember",{
				teamid = self.teamid,
				member = {
					pid = self.captain,
					state = TEAM_CAPTAIN,
				}
			})
		end
	end)
end

function cteam:changecaptain(pid)
	assert(self.captain~=pid)
	local oldcaptain_pid = self.captain
	if playermgr.getplayer(oldcaptain_pid) then
		self.follow[oldcaptain_pid] = true
	else
		self.leave[oldcaptain_pid] = true
	end
	self.captain = pid
	self.follow[pid] = nil
	self.leave[pid] = nil
	self:broadcast(function (uid)
		sendpackage(uid,"team","updatemember",{
			teamid = self.teamid,
			member = {
				pid = oldcaptain_pid,
				state = self.follow[oldcaptain_pid] and TEAM_STATE_FOLLOW or TEAM_STATE_LEAVE,
			}
		})
		sendpackage(uid,"team","updatemember",{
			teamid = self.teamid,
			member = {
				pid = self.captain,
				state = TEAM_CAPTAIN,
			}
		})
	end)
end

function cteam:addapplyer(player)
	local pid = player
	if self.applyers[pid] then
		return
	end
	logger.log("info","team",string.format("addapplyer,pid=%d teamid=%d",pid,self.teamid))
	local applyer = {
		pid = pid,
		name = player.name,
		lv = player.lv,
		roletype = player.roletype,
		time = os.time(),
	}
	self.applyers[pid] = applyer
	self:broadcast(function (uid)
		sendpackage(uid,"team","addapplyer",{applyer,})
	end)
end

function cteam:delapplyer(pid)
	local applyer = self.applyers[pid]
	if applyer then
		logger.log("info","team",string.format("delapplyer,pid=%d teamid=%d",pid,self.teamid))
		self:broadcast(function (uid)
			sendpackage(uid,"team","delapplyer",{applyer,})
		end)
	end
end

function cteam:teamstate(pid)
	if self.captain == pid then
		return TEAM_CAPTAIN
	elseif self.follow[pid] then
		return TEAM_STATE_FOLLOW
	elseif self.leave[pid] then
		return TEAM_STATE_LEAVE
	end
	return NO_TEAM
end

-- player : 1--player object,2 -- resume object
function cteam:packmember(player)
	return {
		pid = player.pid,
		name = player.name,
		lv = player.lv,
		roletype = player.roletype,
		state = self:teamstate(player.pid),	
	}
end

function cteam:packmembers()
	local captain = playermgr.getplayer(self.captain)
	if not captain then
		captain = resumemgr.getresume(self.captain)
	end
	local members = {}
	table.insert(members,self:packmember(captain))
	for i,pid in ipairs(self.follow) do
		local member = playermgr.getplayer(pid)
		if not member then
			member = resumemgr.getresume(pid)
			table.insert(members,self:packmember(member))
		end
	end
	for i,pid in ipairs(self.leave) do
		local member = playermgr.getplayer(pid)
		if not member then
			member = resumemgr.getresume(pid)
			table.insert(members,self:packmember(member))
		end
	end
	return members
end

function cteam:pack()
	return {
		teamid = self.teamid,
		target = self.target,
		stage = self.stage,
		members = self:packmembers(),
		automatch = teammgr.automatch_teams[self.teamid] and true or false,
	}
end

function cteam:broadcast(func)
	func(self.captain)
	for pid,_ in pairs(self.follow) do
		func(pid)
	end
	for pid,_ in pairs(self.leave) do
		func(pid)
	end
end

function cteam:ismember(pid)
	if self.captain == pid then
		return true
	end
	if self.follow[pid] then
		return true
	end
	if self.leave[pid] then
		return true
	end
	return false
end

function cteam:len(state,include_captain)
	if state == TEAM_STATE_FOLLOW then
		return string.len(keys(self.follow)) + (include_captain and 1 or 0)
	elseif state == TEAM_STATE_LEAVE then
		return string.len(keys(self.leave))
	elseif state == TEAM_STATE_OFFLINE then
		local cnt = 0
		for pid,v in pairs(self.leave) do
			if not playermgr.getplayer(pid) then
				cnt = cnt + 1
			end
		end
		return cnt
	elseif state == TEAM_STATE_ALL then
		return 1 + string.len(keys(self.follow)) + string.len(keys(self.leave))
	else
		assert("invalid team state:" .. tostring(state))
	end
end
return cteam
