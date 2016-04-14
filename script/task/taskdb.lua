ctaskdb = class("ctaskdb")

function ctaskdb:init(conf)
	self.pid = assert(conf.pid)
	self.name = assert(conf.name)
	self.tasks = {}
	self.finishtasks = {}
	self.nowtaskid = nil  -- 仅对同时只有一个任务的任务类有效
end

function ctaskdb:load(data)
	if not data or not next(data) then
		return
	end
	local tmp = {}
	for taskid,d in pairs(data.tasks) do
		taskid = tonumber(taskid)
		local task = self:__newtask({taskid=taskid})
		if task then
			task:load(d)
			tmp[taskid] = task
		else 	-- 导表任务删了，__newtask讲返回空
			self:log("info","task",string.format("[load unknow task] pid=%s taskid=%s",self.pid,taskid))
		end
	end
	self.tasks = tmp
	self.nowtaskid = data.nowtaskid
	local finishtasks = data.finishtasks or {}
	for i,taskid in ipairs(finishtasks) do
		self.finishtasks[taskid] = true
	end
end

function ctaskdb:save()
	local data = {}
	local tmp = {}
	for taskid,task in pairs(self.tasks) do
		tmp[tostring(taskid)] = task:save()
	end
	data.tasks = tmp
	data.nowtaskid = self.nowtaskid
	data.finishtasks = table.values(self.finishtasks)
	return data
end

function ctaskdb:clear()
	self:log("info","task",string.format("clear,pid=%s",self.pid))
	if self.onclear then
		self:onclear()
	end
	self.tasks = {}
	-- 累积完成任务又使用者决定是否清空
	--self.finishtasks = {}
end

function ctaskdb:log(levelmode,filename,...)
	levelmode = string.upper(levelmode)
	local msg = table.concat({...},"\t")
	msg = string.format("[%s] [name=%s] %s",levelmode,self.name,msg)
	g_serverinfo:logger(filename,msg)
end

function ctaskdb:onlogin(player)
end

function ctaskdb:onlogoff(player)
end

function ctaskdb:gettask(taskid,nocheckvalid)
	local task = self.tasks[taskid]
	if task then
		if not nocheckvalid then
			if task.exceedtime then
				local now = os.time()
				if now >= task.exceedtime then
					self:deltask(taskid,"timeout")
					return
				end
			end
		end
	end
	return task
end

function ctaskdb:__newtask(conf)
	require "gamelogic.task.init"
	local taskid = assert(conf.taskid)
	local taskdata = self:gettaskdata(taskid)
	if taskdata then
		conf.state = TASK_STATE_ACCEPT
		conf.type = taskdata.type
		if taskdata.exceedtime then
			if taskdata.exceedtime == "today" then
				conf.exceedtime = getdayzerotime() + DAY_SECS + 5 * HOUR_SECS
			elseif taskdata.exceedtime == "thisweek" then
				conf.exceedtime = getweekzerotime() + DAY_SECS * 7 + 5 * HOUR_SECS
			elseif taskdata.exceedtime == "thisweek2" then
				conf.exceedtime = getweek2zerotime() + DAY_SECS * 7 + 5 * HOUR_SECS
			elseif taskdata.exceedtime == "thismonth" then
				local now = os.time()
				conf.exceedtime = os.time({year=getyear(now),month=getyearmonth(now)+1,day=1,hour=5,min=0,sec=0,})
			elseif taskdata.exceedtime == "forever" then
			else
				secs = assert(tonumber(taskdata.exceedtime))
				secs = math.floor(secs)
				conf.exceedtime = os.time() + secs
			end
		end
		return ctask.new(conf)
	end
end

function ctaskdb:addtask(task)
	local taskid = task.taskid
	assert(self.tasks[taskid]==nil,"Repeat taskid:" .. tostring(taskid))
	self:log("info","task",string.format("addtask,pid=%d taskid=%d",self.pid,taskid))
	self.tasks[taskid] = task
	self.nowtaskid = taskid
	if self.onaddtask then
		self:onaddtask(task)
	end
end

function ctaskdb:deltask(taskid,reason)
	local task = self.tasks[taskid] -- 不能用gettask,gettask中有调用deltask
	if task then
		self:log("info","task",string.format("deltask,pid=%d taskid=%d reason=%s",self.pid,taskid,reason))
		self.tasks[taskid] = nil
		self.nowtaskid = nil  -- nowtaskid只对同时只有一个任务的任务类有效
		if self.ondeltask then
			self:ondeltask(task,reason)
		end
		return task
	end
end

function ctaskdb:updatetask(task,key,val)
	task:set(key,val)
	if self.onupdatetask then
		self:onupdatetask(task,key,val)
	end
end

-- 可重写
function ctaskdb:finishtask(taskid)
	self:log("info","task",string.format("finishtask,pid=%d taskid=%d",self.pid,taskid))
	local task = self:gettask(taskid)
	-- 完成任务时，任务可能已失效，如：战斗结束后完成任务，此时可能已不存在，这时仍然需要提交奖励任务
	if task then  
		self:updatetask(task,"state",TASK_STATE_FINISH)
	end
	local taskdata = self:gettaskdata(taskid)
	if istrue(taskdata.autosubmit) then
		-- 无需判断是否可以提交，任务可能已经失效，调用者调用了finishtask,就必须知道可能会“无条件”提交的行为！
		self:submittask(taskid)
	end
	return task
end

-- 可重写,默认不记录“历史已完成任务”
function ctaskdb:addfinishtask(taskid)
	self.finishtasks[taskid] = true
end

function ctaskdb:submittask(taskid)
	self:deltask(taskid,"submit")
	self:addfinishtask(taskid)
	self:bonustask(taskid)
	local taskdata = self:gettaskdata(taskid)
	if istrue(taskdata.autoaccept) then
		local nexttask = self:nexttask(taskid)
		if nexttask then
			if self:can_accepttask(nexttask.taskid) then
				self:accepttask(nexttask)
			end
		end
	end
end

function ctaskdb:accepttask(taskdata)
	local task = self:__newtask(taskdata)
	self:addtask(task)
end

function ctaskdb:giveuptask(taskid)
	local task = self:gettask(taskid)
	if task then
		self:deltask(taskid,"giveup")
		return task
	end
end

function ctaskdb:can_accepttask(taskid)
	local player = playermgr.getplayer(self.pid)
	if not player then
		return false
	end
	local taskdata = self:gettaskdata(taskid)
	local isok = true
	if taskdata.pretask and next(taskdata.pretask) then
		for i,taskid in ipairs(taskdata.pretask) do
			if not self.finishtasks[tid] then
				isok = false
			end
		end
	end
	if not isok then
		return false,string.format("前置任务未完成")
	end
	return true
end

function ctaskdb:can_submittask(taskid)
	local task = self:gettask(taskid)
	if not task then
		return false,"任务已失效"
	end
	if task.state ~= TASK_STATE_FINISH then
		return false,"任务未完成"
	end
	return true
end

function ctaskdb:can_giveuptask(taskid)
	local taskdata = self:gettaskdata(taskid)
	if not istrue(taskdata.cangiveup) then
		return false,"该任务无法放弃"
	end
	return true
end

function ctaskdb:bonustask(taskid)
	local taskdata = self:gettaskdata(taskid)
	local award = taskdata.award
	local reason = string.format("%s.bonustask",self.name)
	self:doaward(award,reason)
end

function ctaskdb:bonus_helpwar(taskid)
	local taskdata = self:gettaskdata(taskid)
	local award = taskdata.help_award
	local reason = string.format("%s.bonus_helpwar",self.name)
	self:doaward(award,reason)
end

return ctaskdb
