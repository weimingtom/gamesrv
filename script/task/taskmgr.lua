require "script.task.auxilary"
require "script.task.taskdb"

ctaskmgr = class("ctaskmgr")

function ctaskmgr:init(pid)
	self.pid = pid
	self.loadstate = "unload"
	self.name_taskdb = {}
end

function ctaskmgr:load(data)
	if not data or not next(data) then
		return
	end
	for name,_ in pairs(self.name_taskdb) do
		local taskdb = self:gettaskdb(name)
		taskdb:load(data[name])
	end
end

function ctaskmgr:save()
	local data = {}
	for name,_ in pairs(self.name_taskdb) do
		local taskdb = self:gettaskdb(name)
		data[name] = taskdb:save()
	end
	return data
end

function ctaskmgr:clear()
	for name,_ in pairs(self.name_taskdb) do
		local taskdb = self:gettaskdb(name)
		taskdb:clear()
	end
end

function ctaskmgr:addtaskdb(taskdb)
	local name = assert(taskdb.name)
	assert(self.name_taskdb[name] == nil)
	self.name_taskdb[name] = true
	self[name] = taskdb
end

function ctaskmgr:gettaskdb(name)
	assert(self.name_taskdb[name] ~= nil)
	return self[name]
end

function ctaskmgr:gettaskdb_by_taskid(taskid)
end

function ctaskmgr:gettask(taskid)
	for name,_ in pairs(self.name_taskdb) do
		local taskdb = self:gettaskdb(name)
		local task = taskdb:gettask(taskid)
		if task then
			return task
		end
	end
end

function ctaskmgr:oncreate(player)
	for name,_ in pairs(self.name_taskdb) do
		local taskdb = self:gettaskdb(name)
		if taskdb.oncreate then
			taskdb:oncreate(player)
		end
	end
end

function ctaskmgr:onlogin(player)
	for name,_ in pairs(self.name_taskdb) do
		local taskdb = self:gettaskdb(name)
		taskdb:onlogin(player)
	end
end

function ctaskmgr:onlogoff(player)
	for name,_ in pairs(self.name_taskdb) do
		local taskdb = self:gettaskdb(name)
		taskdb:onlogoff(player)
	end
end

function ctaskmgr:onchangelv(oldlv,newlv)

end

-- 物品(itemtype)增加数量(num)
function ctaskmgr:onadditem(itemtype,num)
end

-- 物品(itemtype)减少数量(num)
function ctaskmgr:ondelitem(itemtype,num)
end

function ctaskmgr:onaddpet(pettype,num)
end

function ctaskmgr:ondelpet(pettype,num)
end

function ctaskmgr:onfivehourupdate()
	for name,_ in pairs(self.name_taskdb) do
		local taskdb = self:gettaskdb(name)
		if taskdb.onfivehourupdate then
			taskdb:onfivehourupdate(player)
		end
	end
end

return ctaskmgr
