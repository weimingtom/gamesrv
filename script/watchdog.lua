local skynet = require "skynet"
local netpack = require "netpack"

local CMD = {}
local SOCKET = {}
local gate
local agent = {}

--/*
-- 客户端连上服务器（接受一个客户端套接字)
-- @param integer fd 客户端套接字描述符
-- @param string addr 客户端ip:port
--*/
function SOCKET.open(fd, addr)
	agent[fd] = skynet.newservice("script/agent",fd,addr)
	skynet.call(agent[fd], "lua", "start", gate, fd,addr)
end

local function close_agent(fd)
	local a = agent[fd]
	if a then
		skynet.call(a,"lua","close")
		skynet.kill(a)
		agent[fd] = nil
	end
end

--/*
-- 客户端主动断开连接
-- @param integer fd 客户端套接字描述符
--*/
function SOCKET.close(fd)
	--print("socket close",fd)
	skynet.error("socket close",fd)
	close_agent(fd)
end

--/*
-- 客户端连接出错
-- @param integer fd 客户端套接字描述符
-- @param string msg 错误描述
--*/
function SOCKET.error(fd, msg)
	--print("socket error",fd, msg)
	skynet.error("socket error",fd,msg)
	close_agent(fd)
end

--/*
-- 收到客户端数据(该接口暂时没有用到，gate在在收到客户端数据后redirect给agent了)
-- @param integer fd 客户端套接字描述符
-- @param string msg 消息数据
--*/
function SOCKET.data(fd, msg)
	print("socket.data",fd,msg)
end

--/*
-- 启动服务端套接字，监听指定端口
-- @param table conf {port=端口,maxclient=最大连接数,nodelay=true}
--*/
function CMD.start(conf)
	skynet.call(gate, "lua", "open" , conf)
end

skynet.start(function()
	skynet.dispatch("lua", function(session, source, cmd, subcmd, ...)
		if cmd == "socket" then
			local f = SOCKET[subcmd]
			f(...)
			-- socket api don't need return
		else
			local f = assert(CMD[cmd])
			skynet.ret(skynet.pack(f(subcmd, ...)))
		end
	end)

	gate = skynet.newservice("gate")
end)
