cachievementdb = class("cachievementdb",ccontainer)

function cachievementdb:init(pid)
	ccontainer.init(self,{
		pid = pid,
		name = "cachievementdb",
	})
	self.loadstate = "unload"
end

function cachievementdb:load(data)
	if not data or not next(data) then
		return
	end
	self.objid = data.objid
	local objs = {}
	local len = 0
	for k,v in pairs(data.objs) do
		objs[tonumber(k)] = v
		len = len + 1
	end
	self.objs = objs
	self.len = len
end

function cachievementdb:save()
	local data = {}
	data.objid = self.objid
	local objs = {}
	for k,v in pairs(self.objs) do
		objs[tostring(k)] = v
	end
	data.objs = objs
	return data
end

function cachievementdb:clear()
	logger.log("info","achieve",string.format("clear,pid=%s",pid))
	self:clear()
end

function cachievementdb:oncreate(player)
end

function cachievementdb:onlogin(player)
	self:syncall(player)
end

function cachievementdb:onlogoff(player)
end

function cachievementdb:newachieve(achieveid)
	local achieve_data = data_achievement[achieveid]
	return {
		id = achieveid,
		progress = 0,
		target = achieve_data.target,
		bonus = false,
	}
end

function cachievementdb:addachieve(achieve)
	local achieveid = achieve.id
	logger.log("info","achieve",string.format("addachieve,pid=%s achieveid=%s",self.pid,achieveid))
	self:add(achieve,achieveid)
	self:sync(self.pid,achieve)
end

function cachievementdb:delachieve(achieveid)
	local achieve = self:getachieve(achieveid)
	if achieve then
		logger.log("info","achieve",string.format("delachieve,pid=%s achieveid=%s",self.pid,achieveid))
		self:del(achieveid)
		-- sync to client
	end
end

function cachievementdb:getachieve(achieveid)
	return self:get(achieveid)
end

function achievementdb:checkachieve(achieveid,num)
	local achieve = self:getachieve(achieveid)
	if not achieve then
		achieve = self:newachieve(achieveid)
		self:addachieve(achieve)
	end
	if achieve.progress < achieve.target then
		logger.log("info","achieve",string.format("checkachieve,pid=%s achieveid=%s progress=%d+%d",self.pid,achieve.progress,num))
		achieve.progress = achieve.progress + num
		self:sync(self.pid,achieve)
	end
end

function cachievementdb:syncall(pid)
end

function cachievementdb:sync(pid,achieve)
end

function cachievementdb.getbyevent(eventname)
	if not cachievementdb.event2achievements then
		cachievementdb.event2achievements = {}
	end
	if not cachievementdb.event2achievements[eventname] then
		cachievementdb.event2achievements[eventname] = {}
	end

	for id,v in pairs(data_achivement) do
		if type(id) == "number" then
			table.insert(cachievementdb.event2achievements[eventname],id)
		end
	end
	return cachievementdb.event2achievements[eventname]
end

function __hotfix(oldmod)
	cachievementdb.event2achievements = nil
end

return cachievementdb
