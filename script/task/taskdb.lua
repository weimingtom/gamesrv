ctaskdb = class("ctaskdb")

function ctaskdb:init(pid)
	self.pid = pid
	self.tasks = {}
	self.finishtasks = {}
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
	local data = data_task_ctrl[name]
	if self.circle > data.limit and data.isloop == 1 then
		self.circle = self.circle % data.limit
	end
	sendpackage(self.pid,"task",circle,{
		name = self.circle[name],
	})
end

function ctaskdb:gettask(taskid)
	return self.tasks[taskid]
end

function ctaskdb:addtask(task)
	local taskid = task.taskid
	local name = gettask_typename(taskid)
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
	self:settaskstate(task,TASK_STATE_FINISH,true)
	local taskdata = gettaskdata(taskid)
	if taskdata.autosubmit then
		self:submittask(task)
	end
end

function ctaskdb:submittask(task)
	local taskid = task.taskid
	self:deltask(taskid,"submit")
	self.finishtasks[taskid] = true
	self:bonustask(task)
	local taskdata = gettaskdata(taskid)
	if taskdata.autoaccept then
		local ratios = {}
		for tid,ratio in pairs(taskdata.nexttask) do
			if self:canaccepttask(tid) then
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
	local taskdata = gettaskdata(taskid)
	local task = ctask.new(taskdata)
	self:addtask(task)
end

function ctaskdb:giveuptask(taskid)
	local task = self:gettask(taskid)
	if task then
		self:deltask(taskid,"giveup")
		return task
	end
end

function ctaskdb:settaskstate(task,newstate,nolog)
	local oldstate = task.state
	if not nolog then
		logger.log("info","task",string.format("settaskstate,pid=%d state=%d->%d",oldstate,newstate))
	end
	task.state = newstate
end

function ctaskdb:canaccepttask(taskid)
	local player = playermgr.getplayer(pid)
	if not player then
		return false
	end
	local taskdata = gettaskdata(taskid)
	if islvenough(player.lv,taskdata.openlv) then
		return false,string.format("等级不足#<R>%d#级",taskdata.openlv)
	end
	local isok = false
	if taskdata.pretask and next(taskdata.pretask) then
		for i,taskids in ipairs(taskdata.pretask) do
			local bfinish = true
			for i,tid in ipairs(taskids) do
				if not self.finishtasks[tid] then
					bfinish = false
					break
				end
			end
			if bfinish then
				isok = true
				break
			end
		end
	end
	if not isok then
		return false,string.format("前置任务未完成")
	end
	return true
end

function ctaskdb:cansubmittask(taskid)
	local task = self:gettask(taskid)
	if not task then
		return false
	end
	if task.state ~= TASK_STATE_FINISH then
		return false,"任务未完成"
	end
	return true
end

function ctaskdb:cangiveuptask(taskid)
	local taskdata = gettaskdata(taskid)
	if not taskdata.cangiveup then
		return false
	end
	return true
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

function gettask_typename(taskid)
	local typ = gettasktype2(taskid)
	local name = TASK_TYPE_NAME[typ]
	return name
end

function gettaskdata(taskid)
	local typ
	if taskid < 10000 then
		typ = taskid
	else
		typ = gettasktype2(taskid)
	end
	if typ == TASK_TYPE_MAIN then
	elseif typ == TASK_TYPE_BRANCH then
	elseif typ == TASK_TYPE_SHIMEN then
		return data_task_shimen
	end
end

return ctaskdb
