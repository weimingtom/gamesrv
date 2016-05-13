--- usage:
--- local profiler = require "script.profiler"
--- profiler.init()
--- profiler.start()
--- some code
--- profiler.stop()
--- profiler.sort(xxx)
--- profiler.dump(xxx)
profiler = profiler or {}

function profiler.init()
	profiler.MAXTIME = 100
	profiler.stat = {}
	profiler.dump_stat = {}
end

local function getfuncname(func)
	local debug_info = debug.getinfo(func,"Sn")
	local name = string.format("[%s]:%d ([%s] %s)",debug_info.short_src,debug_info.linedefined,debug_info.what,debug_info.name)
	return name
end

local function getrunningfunc()
	return debug.getinfo(3,"f").func
end

function profiler.create_profile(func)
	assert(profiler.stat[func] == nil)
	local info = {
		call_cnt = 0,
		sum_time = 0,
		avg_time = 0,
		max_time = 0,
		min_time = profiler.MAXTIME,
		name = getfuncname(func),
		func = func,
		--
		starttime = 0,
		endtime = 0,
		ref = 0,
	}
	profiler.stat[func] = info
	return info
end

function profiler.getprofile(func)
	return profiler.stat[func]
end

function profiler.trace(event,line)
	local func = getrunningfunc()
	if not profiler.getprofile(func) then
		profiler.create_profile(func)
	end
	local prof = profiler.getprofile(func)
	--print(prof.name,prof.func)
	if event == "call" then
		prof.ref = prof.ref + 1
		prof.starttime = os.clock()	
	elseif event == "return" then
		prof.ref = prof.ref - 1
		if prof.ref == 0 then
			prof.endtime = os.clock()
			local costtime = prof.endtime - prof.starttime
			--print(prof.name,prof.endtime,prof.starttime,costtime)
			prof.sum_time = prof.sum_time + costtime
			if costtime > prof.max_time then
				prof.max_time = costtime
			end
			if costtime < prof.min_time then
				prof.min_time = costtime
			end
			prof.call_cnt = prof.call_cnt + 1
		end
	end
end

function profiler.sort(key)
	local function cmp(lhs,rhs)
		if key == "avg_time" then
			return lhs.sum_time / lhs.call_cnt < rhs.sum_time / rhs.call_cnt
		else
			return lhs[key] < rhs[key]
		end
	end
	profiler.sort_key = key
	for func,prof in pairs(profiler.stat) do
		if prof.call_cnt ~= 0 then --忽略profile.start,profile.end
			table.insert(profiler.dump_stat,prof)		
		end
	end
	table.sort(profiler.dump_stat,cmp)
end

function profiler.dump(print,cond)
	cond = cond or function (prof) return true end
	local head_fmt = "%10s  %10s  %10s  %14s  %10s  %s"
	local fmt = "%10.6f  %10.6f  %10d  %14.6f  %10.6f  %s"
	print(string.format("profiler sort by %s",profiler.sort_key))
	print(string.format(head_fmt,"max_time","min_time","call_cnt","sum_time","avg_time","name"))
	for _,prof in ipairs(profiler.dump_stat) do
		if cond(prof) then
			local avg_time = prof.sum_time / prof.call_cnt
			print(string.format(fmt,prof.max_time,prof.min_time,prof.call_cnt,prof.sum_time,avg_time,prof.name))		
		end
	end
end

function profiler.start()
	debug.sethook(profiler.trace,"cr")
end

function profiler.stop()
	debug.sethook()
end

return profiler

