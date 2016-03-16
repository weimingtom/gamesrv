timer = timer or {
	timers = {},
	id = 0,
}
function timer.timeout(flag,ti,func)
	ti = ti * 100
	return timer.timeout2(flag,ti,func)
end

function timer.timeout2(flag,ti,func)
	logger.log("debug","timer",string.format("timeout,flag=%s,ti=%s func=%s",flag,ti,func))
	local id = timer.addtimer(flag,func)
	skynet.timeout(ti,function ()
		timer.ontimeout(flag,id)
	end)
	return id
end

function timer.untimeout(flag,id)
	logger.log("debug","timer",string.format("untimeout,flag=%s,id=%s",flag,id))
	return timer.deltimer(flag,id)
end

function timer.deltimerbyid(id)
	for flag,funcs in pairs(timer.timers) do
		if funcs[id] then
			logger.log("debug","timer",string.format("deltimerbyid,flag=%s,id=%s",flag,id))
			local func = funcs[id]
			funcs[id] = nil
			return func,flag
		end
	end
end


-- private method
function timer.genid()
	if timer.id > MAX_NUMBER then
		timer.id = 0
	end
	timer.id = timer.id + 1
	return timer.id
end

function timer.addtimer(flag,func)
	if not timer.timers[flag] then
		timer.timers[flag] = {}
	end
	local id = timer.genid()
	timer.timers[flag][id] = func
	return id
end

function timer.gettimer(flag,id)
	local timers = timer.timers[flag]
	if not id then
		return timers
	elseif timers then
		return timers[id]
	end
end

function timer.deltimer(flag,id)
	local timers = timer.timers[flag]
	if not id then
		local funcs = timer.timers[flag]
		timer.timers[flag] = nil
		return funcs
	elseif timers then
		local func = timers[id]
		timers[id] = nil
		return func
	end
end


function timer.ontimeout(flag,id)
	local func = timer.gettimer(flag,id)
	if func then
		--func()
		xpcall(func,onerror)
	end
end

return timer
