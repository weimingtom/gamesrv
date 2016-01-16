require "script.task.todaytask.shimen"

ctaskmgr = class("ctaskmgr")

function ctaskmgr:init(pid)
	self.pid = pid
	self.shimen = cshimentask.new(pid)
	self.loadstate = "unload"
end

function ctaskmgr:load(data)
	if not data or not next(data) then
		return
	end
	self.shimen:load(data.shimen)
end

function ctaskmgr:save()
	local data = {}
	data.shimen = self.shimen:save()
	return data
end

function ctaskmgr:oncreate(player)
end

function ctaskmgr:onlogin(player)
end

function ctaskmgr:onlogoff(player)
end

function ctaskmgr:onchangelv(oldlv,newlv)
	for taskid,task in pairs(self.tasks) do
	end
end

-- 物品(itemtype)增加数量(num)
function ctaskmgr:onadditem(itemtype,num)
	for taskid,task in pairs(self.tasks) do
	end
end

-- 物品(itemtype)减少数量(num)
function ctaskmgr:ondelitem(itemtype,num)
	for taskid,task in pairs(self.tasks) do
	end
end

function ctaskmgr:onaddpet(pettype,num)
	for taskid,task in pairs(self.tasks) do
	end
end

function ctaskmgr:ondelpet(pettype,num)
	for taskid,task in pairs(self.tasks) do
	end
end

return ctaskmgr
