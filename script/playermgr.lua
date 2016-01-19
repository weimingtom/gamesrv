playermgr = playermgr or {}

function playermgr.getobject(pid)
	return playermgr.id_obj[pid]
end

function playermgr.getplayer(pid)
	local obj = playermgr.getobject(pid)
	if obj and obj.pid > 0 then
		assert(obj.offline ~= true)
		return obj
	end
end

function playermgr.unloadofflineplayer(pid)
	local player = playermgr.id_offlineplayer[pid]
	if player then
		playermgr.id_offlineplayer[pid] = nil
		del_saveobj(player)
		-- not need savetodatabase
	end
end

function playermgr.loadofflineplayer(pid)
	require "script.player"
	local player = playermgr.id_offlineplayer[pid]
	if not player then
		player = cplayer.new(pid)
		player:loadfromdatabase(true)
		player.offline = true
	end
	print(pid,player:isloaded())
	if player:isloaded() then
		playermgr.id_offlineplayer[pid] = player
	end
	return playermgr.id_offlineplayer[pid]
end

--[[
function playermgr.loadofflineplayer(pid,modname)
	require "script.player"
	modname = modname or "all"
	local player = playermgr.id_offlineplayer[pid]
	if player then
		if modname == "base" then
			if player.loadstate == "loaded" then
				return player
			end
		elseif modname == "all" then
			player:loadfromdatabase(true)
		else
			assert(player.autosaveobj[modname],"Unknow modname:" .. tostring(modname))
			local mod = player.autosave[modname]
			if mod.loadstate == "loaded" then
				return player
			end
		end
	else
		player = cplayer.new(pid)
	end
	player.offline = true
	if modname == "base" then
		player:loadfromdatabase(false)
	elseif modname == "all" then
		player:loadfromdatabase(true)
	else
		assert(player.autosaveobj[modname],"Unknow modname:" .. tostring(modname))
		local mod = player.autosaveobj[modname]
		if not mod.loadstate or mod.loadstate == "unload" then
			mod.loadstate = "loading"
			local data = db:get(db:key("role",self.pid,modname))
			mod:load(data)
			mod.loadstate = "loaded"
		end
	end
	return player
end
]]

function playermgr.getobjectbyfd(fd)
	return playermgr.fd_obj[fd]
end

function playermgr.allplayer()
	return playermgr.id_obj
end

function playermgr.addobject(obj)
	logger.log("info","playermgr","addobject,pid=" .. tostring(obj.pid))
	local pid = obj.pid
	assert(playermgr.id_obj[pid] == nil,"repeat object pid:" .. tostring(pid))
	playermgr.id_obj[pid] = obj
	if obj.__fd then
		playermgr.fd_obj[obj.__fd] = obj
	end
	playermgr.num = playermgr.num + 1
	if obj.__type and obj.__type.__name == "cplayer" then
		playermgr.onlinenum = playermgr.onlinenum + 1
	end
end

function playermgr.delobject(pid,reason)
	obj = playermgr.id_obj[pid]
	if obj then

		logger.log("info","playermgr",string.format("delobject,pid=%d reason=%s",pid,reason))
		-- 保证删除对象前下线
		if obj.__type and obj.__type.__name == "cplayer" then
			xpcall(obj.disconnect,onerror,obj,reason)
		end
		playermgr.id_obj[pid] = nil
		playermgr.num = playermgr.num - 1
		if obj.__type and obj.__type.__name == "cplayer" then
			playermgr.onlinenum = playermgr.onlinenum - 1
		end
		if obj.__fd then
			playermgr.fd_obj[obj.__fd] = nil
		end
		if obj.__saveobj_flag then
			del_saveobj(obj)
		end
	end
	require "script.loginqueue"
	loginqueue.remove(pid)
end

-- 服务端主动踢下线
function playermgr.kick(pid,reason)
	local obj = playermgr.getobject(pid)
	if obj then
		logger.log("info","playermgr",string.format("kick,pid=%d,reason=%s",pid,reason))
		proto.kick(obj.__agent,obj.__fd)
	end
end

function playermgr.kickall(reason)
	for pid,obj in pairs(playermgr.allplayer()) do
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
	
	playermgr.delobject(id1,"nettransfer")
	playermgr.addobject(obj2)
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
	cluster.call(srvname,"modmethod","playermgr",".addtoken",token,{pid=pid,})
	player:ongosrv(srvname)
	net.login.reentergame(pid,{
		srvname = srvname,
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

function playermgr.init()
	logger.log("info","playermgr","init")
	playermgr.num = 0
	playermgr.onlinenum = 0
	playermgr.id_obj = {}
	playermgr.fd_obj = {}
	playermgr.id_offlineplayer = {}

	playermgr.tokens = {}
	playermgr.starttimer_checktoken()
end
return playermgr
