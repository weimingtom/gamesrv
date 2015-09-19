cteam = class("cteam")

function cteam:init(teamid)
	self.teamid = teamid
	self.follow = {}
	self.leave = {}
	self.captain = 0
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
	return data
end

function cteam:jointeam(player)
	local teamid = player.teamid
	assert(teamid==nil)
	local pid = player.pid
	player.teamid = self.teamid
	self.leave[pid] = true
	local scene = scenemgr.getscene(player.sceneid)
	scene:sync(pid,{
		teamid = self.teamid,
		state = player:teamstate(),
	})
end

function cteam:backteam(player)
	local pid = player.pid
	local captain = playermgr.getplayer(self.captain)
	local scene = scenemgr.getscene(captain.sceneid)
	if self.leave[pid] then
		self.leave[pid] = nil
	end
	self.follow[pid] = true
	scene:sync(pid,{
		sceneid = captain.sceneid,
		x = captian.x,
		y = captain.y,
		dir = captain.dir,
		teamid = self.teamid,
		state = player:teamstate(),
	})
end

function cteam:leaveteam(player)
	local pid = player.pid
	self.follow[pid] = nil
	self.leave[pid] = true
	local scene = scenemgr.getscene(player.sceneid)
	scene:sync(pid,{
		teamid = self.teamid,
		state = player:teamstate(),
	})
end

function cteam:quitteam(player)
	local pid = player.pid
	player.teamid = nil	
	self.follow[pid] = nil
	self.leave[pid] = nil
	local scene = scenemgr.getscene(player.sceneid)
	scene:sync(pid,{
		teamid = nil,
		state = player:teamstate(),
	})
end

return cteam
