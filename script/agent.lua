local skynet = require "skynet"

local netpack = require "netpack"
local socket = require "socket"
local sproto = require "sproto"
local mc = require "multicast"

local CMD = {}
local agent = {}

function agent.sendpackage(pack)
	if agent.fd then
		local size = #pack
		assert(size <= 65535)
		local package = string.char(math.floor(size/256))..
						string.char(size%256) ..
						pack

		socket.write(agent.fd, package)
	end
end

function agent.reloadproto()
	-- slot 1,2 set at main.lua
	local sprotoloader = require "sprotoloader"
	agent.host = sprotoloader.load(1):host "package"
	agent.send_request = agent.host:attach(sprotoloader.load(2))

end

skynet.register_protocol { 
	name = "client",
	id = skynet.PTYPE_CLIENT,
	unpack = function(msg,sz)
		return agent.host:dispatch(msg,sz)
	end,
	dispatch = function(session,source,typ,...)
		if typ == "REQUEST" then
			local cmd,request,response = ...
			local result = skynet.call(".MAINSRV","lua","client","data",typ,cmd,request)
			if response then
				local result = response(result)
				agent.sendpackage(result)	
			end
		else
			assert(typ == "RESPONSE")
			skynet.send(".MAINSRV","lua","client","data",typ,...)
		end
	end,
}

function CMD.start(gate, fd,addr)
	agent.fd = fd
	agent.ip = addr
	agent.gate = gate
	
	agent.reloadproto()
	skynet.call(gate, "lua", "forward", fd)
	skynet.send(".MAINSRV","lua","client","start",fd,addr)
end

function CMD.close()
	agent.fd = nil
	agent.ip = nil
	agent.gate = nil
	skynet.send(".MAINSRV","lua","client","close")
end

function CMD.kick(fd)
	print("agent.kick",fd)
	skynet.call(agent.gate,"lua","kick",fd)
end

function CMD.send_request(cmd,request,session)
	local pack = agent.send_request(cmd,request,session)
	agent.sendpackage(pack)
end

function CMD.sendpackage(pack)
	agent.sendpackage(pack)
end

local channels = {}
-- channel
function CMD.subscribe(channel)
	assert(channel)
	local c = channels[channel]
	if not c then
		c = mc.new {
			channel = channel,
			dispatch = function (channel,source,cmd,request,session)
				--print(string.format("%s <=== %s %s",skynet.address(skynet.self()),skynet.address(source), channel), ...)
				CMD.send_request(cmd,request,session)
			end
		}
		channels[channel] = c
		print("subscribe",channel,c.channel,c)
		c:subscribe()
	end

end

function CMD.unsubscribe(channel)
	assert(channel)
	local c = channels[channel]
	if c then
		print("unsubscribe",channel,c.channel,c)
		c:unsubscribe()
	end
end

-- proto
function CMD.reloadproto()
	print(skynet.self(),"reloadproto")
	agent.reloadproto()
end

skynet.start(function()
	skynet.dispatch("lua", function(session,source, cmd, ...)
		local f = CMD[cmd]
		--print("agent.dispatch",f,command,...)
		f(...)
	end)
end)

return agent
