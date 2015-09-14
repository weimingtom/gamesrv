require "script.db"
require "script.logger"
require "script.attrblock.saveobj"
require "script.globalmgr"
require "script.conf.srvlist"

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

function playermgr.loadofflineplayer(pid,modname)
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
		if mod.loadstate == "unload" then
			mod.loadstate = "loading"
			local data = db:get(db:key("role",self.pid,modname))
			mod:load(data)
			mod.loadstate = "loaded"
		end
	end
	playermgr.id_offlineplayer[player.pid] = player
	return player
end

function playermgr.getobjectbyfd(fd)
	return playermgr.fd_obj[fd]
end

function playermgr.allplayer()
	local ret = {}
	for pid,_ in pairs(playermgr.id_obj) do
		if pid > 0 then
			table.insert(ret,pid)
		end
	end
	return ret
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
	logger.log("info","playermgr",string.format("delobject,pid=%d reason=%s",pid,reason))
	obj = playermgr.id_obj[pid]
	playermgr.id_obj[pid] = nil
	if obj then
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
		if obj.__type and obj.__type.__name == "cplayer" then
			obj:disconnect(reason)
		end
	end
	require "script.loginqueue"
	loginqueue.remove(pid)
end

function playermgr.newplayer(pid,istemp)
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
	local pid = db:get(db:key("role","maxroleid"),conf.minroleid)
	pid = pid + 1
	if pid > conf.maxroleid then
		return nil
	end
	assert(not db:get(db:key("role",pid)),"maxroleid error")
	db:set(db:key("role","maxroleid"),pid)
	return pid
end

-- 仅在注册时创建临时玩家
function playermgr.createplayer(pid)
	require "script.player"
	logger.log("info","playermgr",string.format("createplayer, pid=%d",pid))
	local player = playermgr.newplayer(pid,true)
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
	local proto = require "script.proto"
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
	cluster.call(srvname,"modmethod","playermgr.addtoken",token,{pid=pid,})
	player:ongosrv(srvname)
	player:exitgame()
	net.login.reentergame(pid,{
		srvname = srvname,
		token = token,
	})	
end

function playermgr.gohome(player)
	local pid = player.pid
	local self_srvname = cserver.srvname
	local srvname = cserver.getsrvname(pid)
	local token = uuid()
	logger.log("info","kuafu",string.format("gohome,pid=%d,srvname=%s->%s token=%s",pid,self_srvname,srvname,token))
	player:ongohome()
	player:exitgame()
	net.login.reentergame(pid,{
		srvname = srvname,
		token = token,
	})
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
