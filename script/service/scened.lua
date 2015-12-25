require "script.constant.init"
require "script.logger.init"
local skynet = require "script.skynet"

local function sendpackage(agent,protoname,cmd,request)
	skynet.send(agent,"lua","send_request",protoname .. "_" .. cmd,request)
end

local scene = {}

function scene.init(sceneid)
	--[[
		key: pid
		value:{
			pid 玩家ID
			teamid	 队伍ID
			state 队伍状态
			warstate 战斗状态
			pos {
				x
				y
				dir
			}
			seen { 视觉范围
				wedith
				height
			}
			police	同步策略(1--显示所有，2--只显示队长(包括暂离玩家和散人)，3--只显示自己队伍/自身)
			agent 
		}
	]]
	scene.sceneid = sceneid
	scene.players = {}
	scene.address = skynet.self()
end

function scene.getplayer(pid)
	return scene.players[pid]
end

function scene.canmove(pid)
	local player = scene.getplayer(pid)
	if not player then
		return false
	end
	if player.warstate == INWAR then
		return false
	end
	if player.teamstate == TEAM_STATE_FOLLOW then
		return false
	end
	return true
end


function scene.set(pid,key,val)
	local attrs
	if not val then
		assert(type(key) == "table")
		attrs = key
	else
		attrs = {[key]=val,}
	end
	local player = scene.getplayer(pid)
	if player then
		for k,v in pairs(attrs) do
			player[k] = v
		end
		local package = {
			pid = pid,
			attrs,
		}
		scene.broadcast(function (obj)
			if obj then
				sendpackage(obj.agent,"scene","update",package)
			end
		end)
	end
end

function scene.canseen(obj,player)
	local x1,y1 = obj.pos.x,obj.pos.y	
	local width,height = obj.seen.width,obj.seen.height
	if x1-width <= player.pos.x and player.pos.x <= x1+width and
	   y1-height <= player.pos.y and player.pos.y <= y1+height then
	   return true
   end
   return false
end

-- 受限发包
function scene.sendpackage(uid,protoname,cmd,package)
	local pid = package.pid
	local obj = scene.getplayer(uid)
	local player = scene.getplayer(pid)
	if not obj or not player then
		return
	end
	if obj.agent then
		if scene.canseen(obj,player) then
			if obj.police then
				if obj.police == POLICE_SEE_SELF then
				elseif obj.police == POLICE_SEE_CAPTAIN then
					sendpackage(obj.agent,protoname,cmd,package)
				elseif obj.police == POLICE_SEE_ALL then
					sendpackage(obj.agent,protoname,cmd,package)
				end
			end
		end
	end
end

function scene.move(pid,package)
	local player = scene.getplayer(pid)
	if not player then
		return
	end
	if not scene.canmove(pid) then
		return
	end
	local srcpos = package.srcpos	
	local dstpos = package.dstpos
	player.pos = {
		x = srcpos.x,
		y = srcpos.y,
		dir = srcpos.dir,
	}
	package.pid = pid
	for uid,obj in pairs(scene.players) do
		if player.teamid then
			if obj.teamid == player.teamid then
				if player.teamstate == TEAM_STATE_CAPTAIN then
					obj.pos = {
						x = player.x,
						y = player.y,
						dir = player.dir,
					}
					if obj.agent then
						sendpackage(obj.agent,"scene","move",package)
					end
				else -- TEAM_STATE_LEAVE
					scene.sendpackage(uid,"scene","move",package)
				end
			else
				scene.sendpackage(uid,"scene","move",package)
			end
		else
			scene.sendpackage(uid,"scene","move",package)
		end
	end
end

function scene.stop(pid)
	local player = scene.getplayer(pid)
	if not player then
		return
	end
	if not scene.canmove(pid) then
		return
	end
	local package = {
		pid = pid,
	}
	for uid,obj in pairs(scene.players) do
		if player.teamid then
			if obj.teamid == player.teamid then
				if player.teamstate == TEAM_STATE_CAPTAIN then
					if obj.agent then
						sendpackage(obj.agent,"scene","stop",package)
					end
				else -- TEAM_STATE_LEAVE
					scene.sendpackage(uid,"scene","stop",package)
				end
			else
				scene.sendpackage(uid,"scene","stop",package)
			end
		else
			scene.sendpackage(uid,"scene","stop",package)
		end
	end
end

function scene.setpos(pid,pos)
	local player = scene.getplayer(pid)
	if not player then
		return
	end
	if not scene.canmove(pid) then
		return
	end
	logger.log("debug","scene",string.format("setpos,address=%s sceneid=%d pid=%d pos(x=%s,y=%s,dir=%s)",scene.address,scene.sceneid,pid,pos.x,pos.y,pos.dir))
	player.pos = pos
	local package = {
		pid = pid,
		pos = pos,
	}
	for uid,obj in pairs(scene.players) do
		if player.teamid then
			if obj.teamid == player.teamid then
				if player.teamstate == TEAM_STATE_CAPTAIN then
					obj.pos = player.pos
					if obj.agent then
						sendpackage(obj.agent,"scene","setpos",package)
					end
				else -- TEAM_STATE_LEAVE
					scene.sendpackage(uid,"scene","setpos",package)
				end
			else
				scene.sendpackage(uid,"scene","setpos",package)
			end
		else
			scene.sendpackage(uid,"scene","setpos",package)
		end
	end
end

function scene.enter(player)
	local pid = player.pid
	if scene.players[pid] then
		logger.log("warning","scene",string.format("reenter,address=%s sceneid=%d pid=%d player=%s",scene.address,scene.sceneid,pid,scene.sceneid,pid,player))

	end
	logger.log("info","scene",string.format("enter,address=%s sceneid=%d pid=%d player=%s",scene.address,scene.sceneid,pid,scene.sceneid,pid,player))
	scene.players[pid] = player
	local package = {
		pid = pid,
		resume = player,
	}
	scene.broadcast(function (obj)
		if obj.agent then
			sendpackage(obj.agent,"scene","enter",package)
		end
	end)
end

function scene.exit(pid)
	local player = scene.players[pid]
	if player then
		logger.log("info","scene",string.format("[%s] exit,address=%s sceneid=%d pid=%d",scene.address,scene.sceneid,scene.sceneid,pid))
		scene.players[pid] = nil
	end
	local package = {
		pid = pid,
	}
	scene.broadcast(function (obj)
		if obj.agent then
			sendpackage(obj.agent,"scene","exit",package)
		end
	end)
end

-- 退出服务
function scene.quit()
	for pid,player in pairs(scene.players) do
		scene.exit(pid)
		skynet.send(".MAINSRV","data","service","scene","quit",pid)
	end
	skynet.exit()
end

function scene.broadcast(func)
	for pid,player in pairs(scene.players) do
		func(player)
	end
end

local command = {
	init = scene.init,
	move = scene.move,
	stop = scene.stop,
	setpos = scene.setpos,
	set = scene.set,
	enter = scene.enter,
	exit = scene.exit,
	quit = scene.quit,
}

skynet.start(function ()
	skynet.dispatch("lua",function (session,source,cmd,...)
		local func = command[cmd]
		if not func then
			logger.log("warning","error",string.format("[scene] invalid cmd:%s",cmd))
			return
		end
		func(...)
	end)
end)
