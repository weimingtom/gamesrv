local mc = require "multicast"

channel = channel or {}

function channel.init()
	channel.channels = {}
	channel.add("world")
end

function channel.add(name,...)
	if select("#",...) > 0 then
		local args = table.pack(...)
		table.insert(args,1,name)
		name = table.concat(args,"#")
	end
	assert(name)
	assert(channel.channels[name]==nil)
	local chan = mc.new()
	logger.log("info","channel",string.format("[add] name=%s channel=%s",name,chan.channel))
	channel.channels[name] = chan
end

function channel.del(name,...)
	if select("#",...) > 0 then
		local args = table.pack(...)
		table.insert(args,1,name)
		name = table.concat(args,"#")
	end
	local chan = channel.get(name)
	if chan then
		logger.log("info","channel",string.format("[del] name=%s channel=%s",name,chan.channel))
		chan:delete()
		channel.channels[name] = nil
	end
end

function channel.get(name,...)
	if select("#",...) > 0 then
		local args = table.pack(...)
		table.insert(args,1,name)
		name = table.concat(args,"#")
	end
	return channel.channels[name]
end

function channel.publish(name,...)
	local chan = channel.get(name)
	if chan then
		logger.log("debug","channel",format("[publish] name=%s channel=%s pack=%s",name,chan.channel,{...}))
		chan:publish(...)
	end
end

function channel.subscribe(name,pid)
	local chan = channel.get(name)
	if not chan then
		return
	end
	local player = playermgr.getplayer(pid)
	if not player then
		return
	end
	local agent = player.__agent
	logger.log("info","channel",string.format("[subscribe] name=%s channel=%s pid=%s",name,chan.channel,pid))
	skynet.send(agent,"lua","subscribe",chan.channel)
end

function channel.unsubscribe(name,pid,reason)
	local chan = channel.get(name)
	if not chan then
		return
	end
	local player = playermgr.getplayer(pid)
	if not player then
		return
	end
	local agent = player.__agent
	logger.log("info","channel",string.format("[unsubscribe] name=%s channel=%s pid=%s reason=%s",name,chan.channel,pid,reason))
	skynet.send(agent,"lua","unsubscribe",chan.channel)
end

return channel
