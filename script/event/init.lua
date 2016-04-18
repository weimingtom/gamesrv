event = event or {}

function event.init()
	event.trigger = {}
end

function event.playerdo(pid,name,num)
	local player = playermgr.getplayer(pid)
	if not player then
		return
	end
	-- check achieve
	local achieves = cachievedb.getbyevent(name)	
	for i, achieveid in ipairs(achieves) do
		player.achievedb:checkachieve(achieveid,num)
	end

	local func = event.trigger[name]
	if not func then
		logger.log("warning","event",string.format("[unknow event] name=%s",name))
		return
	end
	return func(pid,num)
end

function event.register(name,func)
	event.trigger[name] = func
end

function event.onaddgold(pid,addgold)
end

function event.onkillmonster(pid,killnum)
end

return event
