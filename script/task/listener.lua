function refreshtask(player,task)
	local pid = player.pid
	sendpackage(pid,"task","updatetask",task:pack())
end

task_collect_item = task_collect_item or {}
function task_collect_item:onadditem(pid,itemtype,num)
	local player = playermgr.getplayer(pid)
	if not player then
		return
	end
	local taskid = self.taskid
	local taskdata = gettaskdata(taskid)
	if taskdata.param.type == itemtype then
		self.data.progress = (self.data.progress or 0) + num
		local needrefresh = true
		if self.data.progress >= taskdata.param.num then
			if self.state ~= TASK_STATE_FINISH then
				player.taskdb:finishtask(self)
				needrefresh = false
			end
		end
		if needrefresh then
			refreshtask(player,self)
		end
	end
end

function task_collect_item:ondelitem(pid,itemtype,num)
	local player = playermgr.getplayer(pid)
	if not player then
		return
	end
	num = math.abs(num)
	local taskid = self.taskid
	local taskdata.getaskdata(taskid)
	if taskdata.param.type == itemtype then
		self.data.progress = (self.data.progress or 0) - num
		if self.data.progress < taskdata.param.num then
			if self.state == TASK_STATE_FINISH then
				player.taskdb:settaskstate(TASK_STATE_ACCEPT)
			end
		end
		refreshtask(player,self)
	end
end

listener_taskid = listener_taskid or {}

listener_tasktype = listener_tasktype or {}
listener_tasktype[TASK_TYPE_COLLECT_ITEM] = task_collect_item

task_listener = task_listener or {}

local task = task_listener

function task:onadditem(pid,itemtype,num)
	local taskid = self.taskid
	local callback = listener_taskid[taskid]
	if callback and callback.onadditem then
		return callback.onadditem(self,pid,itemtype,num)
	end
	local type1 = gettasktype1(taskid)
	local callback = listener_tasktype[type1]
	if callback and callback.onadditem then
		return callback.onadditem(self,pid,itemtype,num)
	end
end

function task:ondelitem(pid,itemtype,num)
	local taskid = self.taskid
	local callback = listener_taskid[taskid]
	if callback and callback.ondelitem then
		return callback.ondelitem(self,pid,itemtype,num)
	end
	local type1 = gettasktype1(taskid)
	local callback = listener_tasktype[type1]
	if callback and callback.ondelitem then
		return callback.ondelitem(self,pid,itemtype,num)
	end
end

return task_listener
