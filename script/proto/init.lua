local skynet = require "skynet"
local sproto = require "sproto"
require "script.net"
require "script.playermgr"
require "script.logger"
require "script.object"

proto = proto or {}

function proto.register(protoname)
	local protomod = require("script.proto." .. protoname)
	proto.s2c = proto.s2c .. protomod.s2c
	proto.c2s = proto.c2s .. protomod.c2s
end

function proto.dump()
	local lineno
	local b,e
	logger.print("s2c:")
	lineno = 1
	b = 1
	while true do
		e = string.find(proto.s2c,"\n",b)
		if not e then
			break
		end
		logger.print(lineno,string.sub(proto.s2c,b,e-1))
		b = e + 1
		lineno = lineno + 1
	end
	logger.print("c2s:")
	lineno = 1
	b = 1
	while true do
		e = string.find(proto.c2s,"\n",b)
		if not e then
			break
		end
		logger.print(lineno,string.sub(proto.c2s,b,e-1))
		b = e + 1
		lineno = lineno + 1
	end
end

function proto.sendpackage(agent,protoname,cmd,request,onresponse)
	--local connect = assert(proto.connection[agent],"invalid agent:" .. tostring(agent))
	--
	local connect = proto.connection[agent]
	if not connect then
		return
	end
	connect.session = connect.session + 1
	logger.log("debug","netclient",format("[send] source=%s session=%d pid=%d protoname=%s cmd=%s request = %s onresponse=%s",agent,connect.session,connect.pid,protoname,cmd,request,onresponse))
	logger.pprintf("Request:%s\n",{
		pid = connect.pid,
		session = connect.session,
		agent = skynet.address(agent),
		protoname = protoname,
		cmd = cmd,
		request = request,
		onresponse = onresponse,
	})
	connect.sessions[connect.session] = {
		protoname = protoname,
		cmd = cmd,
		request = request,
		onresponse = onresponse,
	}
	skynet.send(agent,"lua","send_request",protoname .. "_" .. cmd,request,connect.session)
end

local function onrequest(agent,cmd,request)
	local connect = assert(proto.connection[agent],"invalid agent:" .. tostring(agent))
	local obj = assert(playermgr.getobject(connect.pid),"invalid pid:" .. tostring(connect.pid))

	logger.pprintf("REQUEST:%s\n",{
		pid = obj.pid,
		agent = skynet.address(agent),
		cmd = cmd,
		request = request,
	})
	local protoname,subprotoname = string.match(cmd,"([^_]-)%_(.+)") 
	local REQUEST = net[protoname].REQUEST
	local func = assert(REQUEST[subprotoname],"unknow cmd:" .. cmd)

	local r = func(obj,request)
	logger.pprintf("Response:%s\n",{
		pid = obj.pid,
		cmd = cmd,
		response = r,
	})
	return r
end

local function onresponse(agent,session,response)
	local connect = assert(proto.connection[agent],"invlaid agent:" .. tostring(agent))
	local obj = playermgr.getobject(connect.pid)
	-- 替换下线时，旧对象已被删除，忽略其收到的回复
	if not obj then
		return
	end
	logger.pprintf("RESPONSE:%s\n",{
		pid = obj.pid,
		agent = skynet.address(agent),
		session = session,
		response = response,
	})
	local ses = assert(connect.sessions[session],"error session id:" .. tostring(session))
	connect.sessions[session] = nil
	local callback = ses.onresponse
	if not callback then
		callback = net[ses.protoname].RESPONSE[ses.cmd]
	end
	if callback then
		callback(obj,ses.request,response)
	end
end

local function filter(agent,typ,...)
	return false
end

local CMD = {}
proto.CMD = CMD
function CMD.data(agent,typ,...)
	if filter(agent,typ,...) then
		return
	end
	if typ == "REQUEST" then
		local ok,result = pcall(onrequest,agent,...)
		if ok then
			skynet.ret(skynet.pack(result))
		else
			skynet.error(result)
		end
	else
		assert(typ == "RESPONSE")
		onresponse(agent,...)
	end
end

function CMD.start(agent,fd,ip)
	local obj = cobject.new(agent,fd,ip)
	playermgr.addobject(obj)
	proto.connection[agent] = {
		pid = obj.pid,
		session = 0,
		sessions = {},
	}
end

function CMD.close(agent)
	local connect = assert(proto.connection[agent],"invalid agent:" .. tostring(agent))
	connect.sessions = nil
	local pid = assert(connect.pid,"invalid pid:" .. tostring(connect.pid))
	playermgr.delobject(pid,"disconnect")
	proto.connection[agent] = nil
end

local function dispatch (session,source,typ,...)
	require "script.game"
	if not game.initall then
		return
	end
	if typ == "client" then
		local pid = 0
		if proto.connection[source] then
			pid = proto.connection[source].pid
		end
		logger.log("debug","netclient",format("[recv] source=%s session=%d pid=%d typ=%s package=%s",source,session,pid,typ,{...}))
		local cmd = ...
		local f = proto.CMD[cmd]
		xpcall(f,onerror,source,select(2,...))
	elseif typ == "cluster" then
		logger.log("debug","netcluster",format("[recv] source=%s session=%d type=%s package=%s",source,session,typ,{...}))
		xpcall(cluster.dispatch,onerror,session,source,...)
	end
end

function proto.init()
	local data = require "script.proto.proto"
	proto.s2c = data.s2c
	proto.c2s = data.c2s
	--proto.dump()

	proto.connection = {}
	skynet.dispatch("lua",dispatch)
end


return proto
