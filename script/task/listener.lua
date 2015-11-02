function refreshtask(player,task)
	
end

task_collect_item = task_collect_item or {}
function task_collect_item:onadditem(player,itemtype,num)
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

task_listener = task_listener or {}

local task = task_listener

function task:onchangelv(pid,oldlv,newlv)
	local taskid = self.taskid
	local type2 = gettasktype2(taskid)
	i
end


return task_listener
