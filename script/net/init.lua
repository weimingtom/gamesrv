net = net or {}
function net.init()
	net.test = require "script.net.test"
	net.login = require "script.net.login"
	net.msg = require "script.net.msg"
	net.player = require "script.net.player"
	net.friend = require "script.net.friend"
	net.war = require "script.net.war"
	net.mail = require "script.net.mail"
	net.team = require "script.net.team"
	net.scene = require "script.net.scene"
	net.task = require "script.net.task"
	net.kuafu = require "script.net.kuafu"

	skynet.dispatch("lua",net.dispatch)
end

function net.dispatch(session,source,typ,...)
	require "script.game"
	if not game.initall then
		logger.log("warning","error",string.format("recv package but not game.initall"))
		return
	end
	if typ == "client" then -- 客户端消息
		-- proto.dispatch will log
		xpcall(proto.dispatch,onerror,session,source,...)
	elseif typ == "service" then  -- 当前节点“其他服务”消息
		logger.log("debug","netservice",format("[recv] source=%s session=%d package=%s",source,session,{...}))
		xpcall(service.dispatch,onerror,session,source,...)
	elseif typ == "cluster" then  -- 其他节点（集群）消息
		logger.log("debug","netcluster",format("[recv] source=%s session=%d package=%s",source,session,{...}))
		xpcall(cluster.dispatch,onerror,session,source,...)
	elseif typ == "echo" then
		--skynet.ret(skynet.pack(...))
	end
end

return net
