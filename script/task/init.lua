require "script.task.listener"
ctask = class("ctask",task_listener)

function ctask:init(taskid)
	self.taskid = taskid
	self.state = TASK_STATE_ACCEPT
	self.data = {}
end

function ctask:load(data)
	if not data or not next(data) then
		return
	end
	self.taskid = data.taskid
	self.state = data.state
	self.data = data.data
end

function ctask:save()
	local data = {}
	data.taskid = self.taskid
	data.state = self.state
	data.data = self.data
	return data
end

function ctask:pack()
	return self:save()
end

return ctask
