cachievedb = class("cachievedb",ccontainer)

function cachievedb:init(pid)
	ccontainer.init(self,{
		pid = pid,
		name = "cachievedb",
	})
	self.loadstate = "unload"
end

function cachievedb:load(data)
	if not data or not next(data) then
		return
	end
	ccontainer.load(self,data)
end

function cachievedb:save()
	local data = ccontainer.save(self)
	return data
end

function cachievedb:clear()
	logger.log("info","achieve",string.format("clear,pid=%s",self.pid))
	ccontainer.clear(self)
end

function cachievedb:oncreate(player)
end

function cachievedb:onlogin(player)
	self:syncall(player)
end

function cachievedb:onlogoff(player)
end

function cachievedb:newachieve(achieveid)
	local achieve_data = data_achievement[achieveid]
	return {
		id = achieveid,
		progress = 0,
		target = achieve_data.target,
		bonus = false,
	}
end

function cachievedb:addachieve(achieve)
	local achieveid = achieve.id
	logger.log("info","achieve",string.format("addachieve,pid=%s achieveid=%s",self.pid,achieveid))
	self:add(achieve,achieveid)
	self:sync(self.pid,achieve)
end

function cachievedb:delachieve(achieveid)
	local achieve = self:getachieve(achieveid)
	if achieve then
		logger.log("info","achieve",string.format("delachieve,pid=%s achieveid=%s",self.pid,achieveid))
		self:del(achieveid)
		-- sync to client
	end
end

function cachievedb:getachieve(achieveid)
	return self:get(achieveid)
end

function cachievedb:checkachieve(achieveid,num)
	local achieve = self:getachieve(achieveid)
	if not achieve then
		achieve = self:newachieve(achieveid)
		self:addachieve(achieve)
	end
	if achieve.progress < achieve.target then
		logger.log("info","achieve",string.format("checkachieve,pid=%s achieveid=%s progress=%d+%d",self.pid,achieveid,achieve.progress,num))
		achieve.progress = achieve.progress + num
		achieve.progress = math.min(achieve.progress,achieve.target)
		self:sync(self.pid,achieve)
	end
end

function cachievedb:syncall(pid)
end

function cachievedb:sync(pid,achieve)
end

function cachievedb.getbyevent(eventname)
	if not cachievedb.event2achieves then
		cachievedb.event2achieves = {}
	end
	if not cachievedb.event2achieves[eventname] then
		cachievedb.event2achieves[eventname] = {}
		for id,v in pairs(data_achievement) do
			if type(id) == "number" then
				table.insert(cachievedb.event2achieves[eventname],id)
			end
		end
	end

	return cachievedb.event2achieves[eventname]
end

function __hotfix(oldmod)
	cachievedb.event2achieves = nil
end

return cachievedb
