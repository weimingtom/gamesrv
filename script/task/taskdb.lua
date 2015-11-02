ctaskdb = class("ctaskdb")

function ctaskdb:init(pid)
	self.pid = pid
	self.tasks = {}
	self.circle = {} -- 各类任务环数
end

function ctaskdb:onlogin(player)
	local pid = player.pid
	sendpackage(pid,"task","circle",self.circle)
end

function ctaskdb:onlogoff(player)
end

function ctaskdb:addcircle(name,addnum)
	self.circle[name] = (self.circle[name] or 1) + addnum
	local data = data_task_circle[name]
	if self.circle > data.limit and data.repeat then
		self.circle = self.circle % data.limit
	end
end

function ctaskdb:gettask(taskid)
	return self.tasks[taskid]
end

function ctaskdb:addtask(task)
	local taskid = task.taskid
	local type2 = gettasktype2(taskid)
	local name = TASK_TYPE_NAME[type2]
	self:addcircle(name,1)
	logger.log("info","task",string.format("addtask,pid=%d taskid=%d circle=%d",self.pid,taskid,self.circle[name]))
	self.tasks[taskid] = task
end

function ctaskdb:deltask(taskid,reason)
	local task = self.tasks[taskid]
	if task then
		logger.log("info","task",string.format("deltask,pid=%d taskid=%d reason=%s",self.pid,taskid,reason))
		self.tasks[taskid] = nil
		return task
	end
end

function ctaskdb:finishtask(task)
	local taskid = task.taskid
	local oldstate = task.state
	logger.log("info","task",string.format("finishtask,pid=%d taskid=%d",self.pid,taskid))
	task.state = TASK_STATE_FINISH
	local taskdata = gettaskdata(taskid)
	if taskdata.autosubmit then
		self:submittask(task)
	end
end

function ctaskdb:submittask(task)
	local taskid = task.taskid
	self:deltask(taskid,"submit")
	self:bonustask(task)
	local taskdata = gettaskdata(taskid)
	if taskdata.autoaccept then
		local ratios = {}
		for tid,ratio in pairs(taskdata.nexttask) do
			if self:canaccept(tid) then
				ratios[tid] = ratio
			end
		end
		if next(ratios) then
			local newtaskid = choosekey(ratios)
			self:accepttask(newtaskid)
		end
	end
end

function ctaskdb:bonustask(task)
	local taskid = task.taskid
	local taskdata = gettaskdata(taskid)
	if taskdata.award then
		local player = playermgr.getplayer(self.pid)
		if player then
			doaward("player",self.pid,taskdata.award,"bonustask",true)
		end
	end
end

function ctaskdb:accepttask(taskid)
	local task = ctask.new(taskid)
	self:addtask(task)
end

function ctaskdb:giveuptask(taskid)
	local task = self:gettask(taskid)
	if task then
		self:deltask(taskid,"giveup")
		return task
	end
end

function ctaskdb:load(data)
	if not data or not next(data) then
		return
	end
	local tmp = {}
	for taskid,d in pairs(data.tasks) do
		local task = ctask.new(taskid)
		task:load(d)
		tmp[tonumber(taskid)] = task
	end
	self.tasks = tmp
end

function ctaskdb:save()
	local data = {}
	local tmp = {}
	for taskid,task in pairs(self.tasks) do
		tmp[tostring(taskid)] = task:save()
	end
	data.tasks = tmp
	return data
end

-- listener
function ctaskdb:onchangelv(oldlv,newlv)
	for taskid,task in pairs(self.tasks) do
		if task.onchangelv then
			task:onchangelv(self.pid,oldlv,newlv)
		end
	end
end

-- 物品(itemtype)增加数量(num)
function ctaskdb:onadditem(itemtype,num)
	for taskid,task in pairs(self.tasks) do
		if task.onadditem then
			task:onadditem(self.pid,itemtype,num)
		end
	end
end

-- 物品(itemtype)减少数量(num)
function ctaskdb:ondelitem(itemtype,num)
	for taskid,task in pairs(self.tasks) do
		if task.ondelitem then
			task:ondelitem(self.pid,itemtype,num)
		end
	end
end

function ctaskdb:onaddpet(pettype,num)
	num = num or 1
	for taskid,task in pairs(self.tasks) do
		if task.onaddpet then
			task:onaddpet(self.pid,pettype,num)
		end
	end
end

function ctaskdb:ondelpet(pettype,num)
	num = num or 1
	for taskid,task in pairs(self.tasks) do
		if task.ondelpet then
			task:ondelpet(self.pid,pettype,num)
		end
	end
end


-- 任务用途
function gettasktype1(taskid)
	return math.floor(taskid / 100000)
end

-- 任务功能
function gettasktype2(taskid)
	local tmp = taskid - gettasktype1(taskid) * 100000
	return math.floor(tmp/10000)
end

function gettaskdata(taskid)
	local typ = gettasktype1(taskid)
	if typ == TASK_TYPE_MAIN then
	elseif typ == TASK_TYPE_BRANCH then
	elseif typ == TASK_TYPE_SHIMEN then
		return data_task_shimen
	end
end

return ctaskdb
