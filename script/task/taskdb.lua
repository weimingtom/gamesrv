ctaskdb = class("ctaskdb")

function ctaskdb:init(pid)
	self.pid = pid
	self.tasks = {}
	self.finishtasks = {}
end

function ctaskdb:load(data)
	if not data or not next(data) then
		return
	end
	local tmp = {}
	for taskid,d in pairs(data.tasks) do
		taskid = tonumber(taskid)
		local task = ctask.new(taskid)
		task:load(d)
		tmp[taskid] = task
		if task.state == TASK_STATE_FINISH then
			self.finishtask[taskid] = true
		end
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


function ctaskdb:onlogin(player)
end

function ctaskdb:onlogoff(player)
end

function ctaskdb:gettask(taskid)
	return self.tasks[taskid]
end

function ctaskdb:addtask(task)
	local taskid = task.taskid
	assert(self.tasks[taskid]==nil,"Repeat taskid:" .. tostring(taskid))
	logger.log("info","task",string.format("addtask,pid=%d taskid=%d",self.pid,taskid))
	self.tasks[taskid] = task
end

function ctaskdb:deltask(taskid,reason)
	local task = self:gettask(taskid)
	if task then
		logger.log("info","task",string.format("deltask,pid=%d taskid=%d reason=%s",self.pid,taskid,reason))
		self.tasks[taskid] = nil
		return task
	end
end


-- 可重写
function ctaskdb:finishtask(taskid)
	local task = self:gettask(taskid)
	if not task then
		return
	end
	local taskid = task.taskid
	local oldstate = task.state
	logger.log("info","task",string.format("finishtask,pid=%d taskid=%d",self.pid,taskid))
	self:settaskstate(taskid,TASK_STATE_FINISH,true)
	local taskdata = gettaskdata(taskid)
	if taskdata.autosubmit then
		self:submittask(taskid)
	end
	return task
end

function ctaskdb:submittask(taskid)
	local task = self:gettask(taskid)
	if not task then
		return
	end
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
	return task
end

function ctaskdb:bonustask(taskid)
	local task = self:getask(taskid)
	if not task then
		return
	end
	local taskid = task.taskid
	local taskdata = gettaskdata(taskid)
	if taskdata.award then
		local player = playermgr.getplayer(self.pid)
		if player then
			doaward("player",self.pid,taskdata.award,"bonustask",true)
		end
	end
	return task
end

function ctaskdb:accepttask(taskid,data)
	local task = ctask.new(taskid,data)
	self:addtask(task)
end

function ctaskdb:giveuptask(taskid)
	local task = self:gettask(taskid)
	if task then
		self:deltask(taskid,"giveup")
		return task
	end
end


function ctaskdb:settaskstate(taskid,newstate,nolog)
	local task = self:gettask(taskid)
	if task then
		local oldstate = task.state
		if not nolog then
			logger.log("info","task",string.format("settaskstate,pid=%d taskid=%d state=%s->%s",self.pid,taskid,oldstate,newstate))
		end
		task.state = newstate
		return task
	end
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


function gettaskdata(taskid)
end

return ctaskdb
