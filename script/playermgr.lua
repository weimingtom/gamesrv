playermgr = playermgr or {}

function playermgr.getobject(pid)
	return playermgr.id_obj[pid]
end

function playermgr.getplayer(pid)
	assert(pid >= 0)
	local player = playermgr.getobject(pid)
	if player then
		if player.__state == "offline" then
			player.__activetime = os.time()
		end
	end
	return player
end

function playermgr.unloadofflineplayer(pid)
	local player = playermgr.getplayer(pid)
	if player then
		if player.__state == "offline" then
			playermgr.delobject(pid,"unloadofflineplayer")
			return player
		end
	end
end

function playermgr.loadofflineplayer(pid)
	require "script.player"
	local player = playermgr.getplayer(pid)
	if player then
		return player
	end
	player = cplayer.new(pid)
	player:loadfromdatabase(true)
	assert(player:isloaded())
	player.__state = "offline"
	playermgr.addobject(player,"loadofflineplayer")
	return player
end

function playermgr.getobjectbyfd(fd)
	local id = playermgr.fd_id[fd]
	if id then
		return playermgr.getobject(id)
	end
end

function playermgr.allobject(state)
	local list = {}
	for pid,obj in pairs(playermgr.id_obj) do
		local mystate = obj.__state or "online"
		if not state or mystate == state then
			table.insert(list,pid)
		end
	end
	return list
end

-- 返回所有在线玩家ID列表
function playermgr.allplayer()
	local list = {}
	for pid,obj in pairs(playermgr.id_obj) do
		local mystate = obj.__state or "online"
		if mystate == "online" then
			table.insert(list,pid)
		end
	end
	return list
end

function playermgr.addobject(obj,reason)
	local pid = obj.pid
	logger.log("info","playermgr",string.format("addobject,pid=%s agent=%s fd=%s state=%s reason=%s",pid,obj.__agent,obj.__fd,obj.__state,reason))
	assert(playermgr.id_obj[pid] == nil,"repeat object pid:" .. tostring(pid))
	playermgr.id_obj[pid] = obj
	if obj.__fd then
		playermgr.fd_id[obj.__fd] = pid
	end
	playermgr.num = playermgr.num + 1
	if obj.__state == "link" then
		playermgr.linknum = playermgr.linknum + 1
	elseif obj.__state == "offline" then
		playermgr.offlinenum = playermgr.offlinenum + 1
	elseif obj.__state == "kuafu" then
		playermgr.kuafunum = playermgr.kuafunum + 1
	else
		playermgr.onlinenum = playermgr.onlinenum + 1
	end
end

function playermgr.delobject(pid,reason)
	obj = playermgr.id_obj[pid]
	if obj then

		logger.log("info","playermgr",string.format("delobject,pid=%d agent=%s fd=%s state=%s reason=%s",pid,obj.__agent,obj.__fd,obj.__state,reason))
		if obj.__state ~= "link" then
			closesave(obj)
		end
		-- 保证删除对象前下线
		if not obj.__state or obj.__state == "online" then
			xpcall(obj.disconnect,onerror,obj,reason)
		end
		playermgr.num = playermgr.num - 1
		if obj.__state == "link" then
			playermgr.linknum = playermgr.linknum - 1
		elseif obj.__state == "offline" then
			playermgr.offlinenum = playermgr.offlinenum - 1
		elseif obj.__state == "kuafu" then
			playermgr.kuafunum = playermgr.kuafunum - 1
		else
			playermgr.onlinenum = playermgr.onlinenum - 1
		end
		playermgr.id_obj[pid] = nil
		if obj.__fd then
			playermgr.fd_id[obj.__fd] = nil
		end

	end
	require "script.loginqueue"
	loginqueue.remove(pid)
end

-- 服务端主动踢下线
function playermgr.kick(pid,reason)
	local obj = playermgr.getobject(pid)
	if obj then
		logger.log("info","playermgr",string.format("kick,pid=%d agent=%s fd=%s state=%s reason=%s",pid,obj.__agent,obj.__fd,obj.__state,reason))
		-- if hasn't '__agent', proto.kick will ignore it
		playermgr.delobject(pid,"kick")
		proto.kick(obj.__agent,obj.__fd)
	end
end

function playermgr.kickall(reason)
	for _,pid in ipairs(playermgr.allobject()) do
		playermgr.kick(pid,reason)
	end
end

function playermgr.newplayer(pid,istemp)
	require "script.player"
	playermgr.unloadofflineplayer(pid)
	if istemp then
		return cplayer.newtemp(pid)
	else
		return cplayer.new(pid)
	end
end

function playermgr.genpid()
	require "script.cluster.route"
	local srvname = skynet.getenv("srvname")
	local conf = srvlist[srvname]
	local db = dbmgr.getdb()
	local pid = db:get(db:key("role","maxroleid")) or conf.minroleid
	pid = pid + 1
	if pid > conf.maxroleid then
		return nil
	end
	assert(not db:get(db:key("role",pid)),"maxroleid error")
	db:set(db:key("role","maxroleid"),pid)
	return pid
end

-- 仅在注册时创建临时玩家
function playermgr.createplayer(pid,conf)
	require "script.player"
	logger.log("info","playermgr",format("createplayer, pid=%d player=%s",pid,conf))
	local db = dbmgr.getdb()
	local maxpid = db:get(db:key("role","maxroleid"),0)
	if pid > maxpid then
		db:set(db:key("role","maxroleid"),pid)
	end
	local player = playermgr.newplayer(pid,true)
	player:create(conf)
	player:nowsave()
	return player
end

function playermgr.recoverplayer(pid)
	assert(tonumber(pid),"invalid pid:" .. tostring(pid))
	require "script.player"	
	local player = playermgr.newplayer(pid)
	player:loadfromdatabase()
	return player
end

function playermgr.nettransfer(obj1,obj2)
	local proto = require "script.proto.init"
	local id1,id2 = obj1.pid,obj2.pid
	logger.log("info","playermgr",string.format("nettransfer,id1=%s id2=%s",id1,id2))
	local agent = assert(obj1.__agent,"link object havn't agent,pid:" .. tostring(id1))
	local connect = assert(proto.connection[agent],"invalid agent:" .. tostring(agent))
	obj2.__agent = agent
	obj2.__fd = obj1.__fd
	obj2.__ip = obj1.__ip
	obj2.__port = obj1.__port
	obj2.__state = "online"	

	playermgr.delobject(id1,"nettransfer")
	playermgr.addobject(obj2,"nettransfer")
	connect.pid = id2	
end

function playermgr.transfer_mark(obj1,obj2)
	obj2.account = obj1.account
	obj2.passwd = obj1.passwd
end


-- 跨服
function playermgr.gosrv(player,srvname)
	local pid = player.pid
	local token = uuid()
	local self_srvname = cserver.srvname
	logger.log("info","kuafu",string.format("gosrv,pid=%d srvname=%s->%s token=%s",pid,self_srvname,srvname,token))
	--cluster.call(srvname,"modmethod","playermgr",".addtoken",token,{pid=pid,})
	cluster.call(srvname,"rpc","playermgr.addtoken",token,{pid=pid,home_srvname=self_srvname})
	player:ongosrv(srvname)
	net.login.reentergame(pid,{
		home_srvname = self_srvname,
		go_srvname = srvname,
		token = token,
	})	
	playermgr.kick(pid)
end

function playermgr.gohome(player)
	local pid = player.pid
	local self_srvname = cserver.srvname
	local srvname = cserver.getsrvname(pid)
	local token = uuid()
	logger.log("info","kuafu",string.format("gohome,pid=%d,srvname=%s->%s token=%s",pid,self_srvname,srvname,token))
	player:ongohome()
	net.login.reentergame(pid,{
		srvname = srvname,
		token = token,
	})
	playermgr.kick(pid)
end

-- token auth
function playermgr.addtoken(token,ext)
	local v = playermgr.tokens[token]
	if v then
		logger.log("error","token",format("addtoken,token=%s ext=%s",token,ext))
	end
	if ext.exceedtime then
		ext.exceedtime = os.time() + ext.exceedtime
	else
		ext.exceedtime = os.time() + 300
	end
	playermgr.tokens[token] = ext
end

function playermgr.gettoken(token)
	return playermgr.tokens[token]
end

function playermgr.deltoken(token)
	playermgr.tokens[token] = nil
end

function playermgr.starttimer_checktoken()
	timer.timeout("timer.starttimer_checktoken",30,playermgr.starttimer_checktoken)
	local now = os.time()
	for token,v in pairs(playermgr.tokens) do
		if v.exceedtime then
			if v.exceedtime < now then
				playermgr.deltoken(token)
			end
		end
	end
end

--/*
-- 所有与玩家相关对象均置入id_obj中，其中包括
-- 连线对象（link)/离线玩家(offline)/跨服玩家（kuafu)/在线玩家（online)
-- 连线对象/在线对象，有连接ID，同时在fd_id中作标记
--*/
function playermgr.init()
	logger.log("info","playermgr","init")
	playermgr.num = 0 -- playermgr.num == playermgr.onlinenum + playermgr.offlinenum + playermgr.kuafunum + playermgr.linknum
	playermgr.onlinenum = 0
	playermgr.offlinenum = 0
	playermgr.kuafunum = 0
	playermgr.linknum = 0
	playermgr.id_obj = {}
	playermgr.fd_id = {}

	-- 跨服对象相关
	playermgr.tokens = {}
	playermgr.starttimer_checktoken()
end
return playermgr
