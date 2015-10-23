local skynet = require "skynet"
local netpack = require "netpack"
local socket = require "socket"
local sproto = require "sproto"

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
	--local proto = require "script.proto.proto"
	--agent.host = sproto.parse(proto.c2s):host "package"
	--agent.send_request = agent.host:attach(sproto.parse(proto.s2c))
	-- slot 1,2 set at main.lua
	local sprotoloader = require "sprotoloader"
	agent.host = sprotoloader.load(1):host "package"
	agent.send_request = agent.host:attach(sprotoloader.load(2))
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

skynet.start(function()
	skynet.dispatch("lua", function(session,source, command, ...)
		local f = CMD[command]
		--print("agent.dispatch",f,command,...)
		f(...)
	end)
end)

return agent
