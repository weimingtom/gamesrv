--/*
-- 跨服流程:主要包括去跨服(取其他服),回原服
-- 假定存在玩家C，他在HS服，有其他GS1，GS2服
-- C从HS服到GS1服:
--	1. HS生成认证token，发到GS1
--	2. HS打包"连接指定服务器"({token=token,go_srvname=GS1,home_srvname=HS})给C
--	3. HS将C踢下线
--	4. C收到"连接指定服务器"时，开始连接GS1,并透传收到的信息(包括认证token)
--	5. GS1根据token认证，认证通过后允许C登录
--	6. GS1通知HS，C跨服成功，HS将C标记成正在跨服GS1
--	7. C走进入游戏流程
--
--	C从GS1服回到原服HS
--	1. GS1生成认证token，发到HS
--	2. GS1打包"连接指定服务器"({token=token,go_srvname=HS})给C
--	3. GS1将C踢下线
--	4. C收到"连接指定服务器"时，开始连接HS,并透传收到的信息(包括认证token)
--	5. HS根据token认证，认证通过后删除C正在跨服标记
--	6. C走进入游戏流程
--
--	C从GS1到GS2
--  1. GS1生成认证token，发到GS2
--	2. GS1打包"连接指定服务器"({token=token,go_srvname=GS2,home_srvname=HS})给C
--	3. GS1将C踢下线
--	4. C收到"连接指定服务器"时，开始连接GS2,并透传收到的信息(包括认证token)
--	5. GS2根据token认证，认证通过由允许C登录
--	6. GS2通知HS，将C的跨服标记置成GS2
--	7. C走进入游戏流程
--*/

--/*
-- 跨服放到玩家身上数据有
-- __state == "kuafu" -- 标记已经去往跨服/其他服
-- home_srvname #原服名
-- go_srvname   #已经去往的跨服（当前所在服务器)
-- home_data    #原服传来的信息
--*/

playermgr = require "script.playermgr"

function playermgr.gosrv(player,go_srvname,home_srvname)
	-- player是连线对象，不一定是玩家对象
	local pid = player.pid
	local now_srvname = cserver.srvname
	if not home_srvname then
		-- home_srvname = cserver.getsrvname(pid)
		if player.home_srvname then
			home_srvname = player.home_srvname
		else
			home_srvname = now_srvname
		end
	end
	assert(go_srvname ~= home_srvname)
	local token = uuid()
	logger.log("info","kuafu",string.format("gosrv,pid=%d home_srvname=%s srvname=%s->%s token=%s",pid,home_srvname,now_srvname,go_srvname,token))
	local player_data = playermgr.packplayer4kuafu(pid)
	cluster.call(go_srvname,"rpc","playermgr.addtoken",token,{
		pid=pid,
		home_srvname=home_srvname,
		player_data = player_data,
	})
	if player.ongosrv then
		player:ongosrv(go_srvname)
	end
	net.login.reentergame(pid,{
		go_srvname = go_srvname,
		token = token,
	})
	playermgr.kick(pid)
end

function playermgr.gohome(player)
	local pid = player.pid
	-- local home_srvname = cserver.getsrvname(pid)
	assert(player.home_srvname)
	local home_srvname = assert(player.home_srvname)
	local now_srvname = cserver.srvname
	assert(home_srvname ~= now_srvname)
	local token = uuid()
	logger.log("info","kuafu",string.format("gohome,pid=%d,srvname=%s->%s token=%s",pid,now_srvname,home_srvname,token))
	cluster.call(home_srvname,"rpc","playermgr.addtoken",token,{pid=pid,})
	player:ongohome(home_srvname)
	net.login.reentergame(pid,{
		go_srvname = home_srvname,
		token = token,
	})
	playermgr.kick(pid)
end

function playermgr.addkuafuplayer(pid)
	local player = playermgr.recoverplayer(pid)
	player.__state = "kuafu"
	-- 跨服对象仅作为一个占位对象,数据同步在db层已做了
	player.nosavetodatabase = true
	playermgr.addobject(player,"addkuafuplayer")
	return player
end

function playermgr.set_go_srvname(pid,go_srvname)
	local player = playermgr.getplayer(pid)
	if not player then
		player = playermgr.addkuafuplayer(pid)
	end
	assert(player.__state == "kuafu")
	player.go_srvname = go_srvname
end

-- 打包与玩家相关的本服全局数据，如服务器等级，开服天数等
function playermgr.packplayer4kuafu(pid)
	return data
end

return playermgr
