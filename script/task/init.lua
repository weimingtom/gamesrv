require "script.task.listener"
ctask = class("ctask",task_listener)

function ctask:init(taskdata)
	self.taskid = taskdata.taskid
	self.state = TASK_STATE_ACCEPT
	if taskdata.exceedtime then
		if taskdata.exceedtime == "today" then
			self.exceedtime = getdayzerotime() + DAY_SECS + 5 * HOUR_SECS
		elseif taskdata.exceedtime == "thisweek" then
			self.exceedtime = getweekzerotime() + DAY_SECS * 7 + 5 * HOUR_SECS
		elseif taskdata.exceedtime == "thisweek2" then
			self.exceedtime = getweek2zerotime() + DAY_SECS * 7 + 5 * HOUR_SECS
		elseif taskdata.exceedtime == "thismonth" then
			local now = os.time()
			self.exceedtime = os.time({year=getyear(now),month=getyearmonth(now)+1,day=1,hour=5,min=0,sec=0,})
		elseif taskdata.exceedtime == "forever" then
		else
			local flag,secs = string.match(taskdata.exceedtime,"^thistemp#%d+$")
			assert(tonumber(secs))
			self.exceedtime = os.time() + secs
		end
	end
	self.data = {}
end

function ctask:load(data)
	if not data or not next(data) then
		return
	end
	self.taskid = data.taskid
	self.state = data.state
	self.exceedtime = data.exceedtime
	self.data = data.data
end

function ctask:save()
	local data = {}
	data.taskid = self.taskid
	data.state = self.state
	data.exceedtime = self.exceedtime
	data.data = self.data
	return data
end

function ctask:pack()
	return self:save()
end

return ctask
