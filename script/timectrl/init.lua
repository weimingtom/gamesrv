require "script.huodong.huodongmgr"
require "script.oscmd.maintain"

timectrl = {}
local INTERVAL = 5 --5 minute

function timectrl.next_fiveminute(now)
	now = now or getsecond()
	local secs = now + INTERVAL * 60
	local min = gethourminute(secs)	
	min = math.floor(min/INTERVAL) * INTERVAL
	local tm = {year=getyear(secs),month=getyearmonth(secs),day=getmonthday(secs),hour=getdayhour(secs),min=min,sec=0,}
	print(self_tostring(tm),min)
	return os.time(tm)
end

function timectrl.starttimer()
	local now = getsecond()
	local next_time = timectrl.next_fiveminute(now)	
	assert(next_time > now,string.format("%d > %d",next_time,now))
	print(next_time,now,next_time-now)
	timer.timeout("timectrl.timer",next_time-now,timectrl.fiveminute_update)
end

function timectrl.init(...)
	logger.log("info","timectrl","timectrl.init")
	timectrl.starttimer()
end

function timectrl.fiveminute_update()
	timectrl.starttimer() 
	timectrl.onfiveminuteupdate()
	now = getsecond()
	local min = gethourminute(now)
	if min % 10 == 0 then
		timectrl.tenminute_update()
	end
end

function timectrl.tenminute_update(now)
	timectrl.ontenminuteupdate()
	local min = gethourminute(now)
	if min == 0 or min == 30 then
		timectrl.halfhour_update()
	end
end

function timectrl.halfhour_update(now)
	timectrl.onhalfhourupdate()
	local min = gethourminute(now)
	if min == 0 then
		timectrl.hour_update(now)
	end
end

function timectrl.hour_update(now)
	timectrl.onhourupdate()
	local hour = getdayhour(now)
	if hour == 0  then
		timectrl.day_update()
	end
end

function timectrl.day_update(now)
	timectrl.ondayupdate()
	local weekday = getweekday(now)
	if weekday == 0 then
		timectrl.week2_update(now)
	elseif weekday == 1 then
		timectrl.week_update(now)
	end
	local day = getmonthday(now)
	if day == 1 then
		timectrl.month_update()
	end
end

function timectrl.week_update(now)
	timectrl.onweekupdate()
end

function timectrl.week2_update(now)
	timectrl.onweek2update()
end

function timectrl.month_update(now)
	timectrl.onmonthupdate()
end

function timectrl.error_handle(...)
	args = {...}
	logger.log("error","timectrl",string.format("[ERROR] %s",self_tostring(args)))
	error("timectrl error")
end

function timectrl.onfiveminuteupdate()
	logger.log("info","timectrl","onfiveminuteupdate")
	huodongmgr.onfiveminuteupdate()
	maintain.onfiveminuteupdate()
end

function timectrl.ontenminuteupdate()
	logger.log("info","timectrl","ontenminuteupdate")
end

function timectrl.onhalfhourupdate()
	logger.log("info","timectrl","onhalfhourupdate")
end


function timectrl.onhourupdate()
	logger.log("info","timectrl","onhourupdate")
end

function timectrl.ondayupdate()
	logger.log("info","timectrl","ondayupdate")
end

function timectrl.onweekupdate()
	logger.log("info","timectrl","onweekupdate")
end

function timectrl.onweek2update()
	logger.log("info","timectrl","onweek2update")
end

function timectrl.onmonthupdate()
	logger.log("info","timectrl","onmonthupdate")
end


return timectrl
