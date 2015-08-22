maintain = maintain or {}

maintain.time = {
	weekday = 4,
	readytime = {20,55},
	starttime = {21,00},
	endtime = {21,10},
}

maintain.msg = "服务器将于%d分钟后进入例行维护，维护时间:%02d:%02d~%02d:%02d"

function maintain.init()
end

function maintain.onfiveminuteupdate()
	local weekday = getweekday()
	weekday = weekday == 0 and 7 or weekday
	if maintain.time.weekday ~= weekday then
		return
	end
	local pass_secs = getdaysecond()
	local readytime = maintain.time.readytime[1] * HOUR_SECS + maintain.time.readytime[2] * 60
	local starttime = maintain.time.starttime[1] * HOUR_SECS + maintain.time.starttime[2] * 60
	local endtime = maintain.time.endtime[1] * HOUR_SECS + maintain.time.endtime[2] * 60
	if readytime <= pass_secs and pass_secs < starttime then
		if maintain.need_maintain() then
			local lefttime = endtime - pass_secs
			local leftmin = math.ceil(lefttime/60)
			if lefttime > 300 then
				local msg = string.format(maintain.msg,leftmin,maintain.time.starttime[1],maintain.time.starttime[2],maintain.time.endtime[1],maintain.time.endtime[2])
				net.msg.bulletin(msg)
			else
				timer.timeout("timer.maintain",60,maintain.onfiveminuteupdate)
			end
		end
	elseif starttime <= pass_secs and pass_secs < endtime then
		if maintain.need_maintain() then
			require "script.game"
			game.shutdown("maintain")
		end
	end
end

function maintain.need_maintain()
	local isok,fd = pcall(io.open,"../shell/maintain.flag")
	return isok and fd
end

function maintain.force_maintain(lefttime)
	maintain.exceedtime = os.time() + lefttime
	maintain.starttimer_maintain()
end

function maintain.starttimer_maintain()
	timer.timeout("timer.force_maintain",60,maintain.starttimer_maintain)
	if maintain.exceedtime then
		local lefttime = maintain.exceedtime - os.time()
		local msg = string.format("服务器将于%d秒后进入紧急维护，请做好下线准备，并相互告知",lefttime)
		if lefttime <= 0 then
			maintain.exceedtime = nil
			require "script.game"
			game.shutdown("force_maintain")
		else
			net.msg.bulletin(msg)
		end
	end
end

return maintain
