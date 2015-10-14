require "script.base.constant"

local scene = {}

function scene.init()
	--[[
		key: pid
		value:{
			pid 玩家ID
			teamid	 队伍ID
			teamstate 队伍状态
			warstate 战斗状态
			x
			y
			dir
			seen	视觉范围
			police	同步策略(1--显示所有，2--只显示队长(包括暂离玩家和散人)，3--只显示自己队伍/自身)
			agent 
		}
	]]
	scene.players = {}
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

function scene.canseen(pid,tid)
	local player = scene.getplayer(pid)
	local target = scene.getplayer(pid)
	if not player or not target then
		return false
	end
end

local command = {}
function command.set(pid,key,val)
	local player = scene.getplayer(pid)
	if player then
		player[key] = val
	end
end

function scene.canseen(obj,player)
	local x1,y1 = obj.x,obj.y	
	local width,height = obj.width,obj.height
	if x1-width <= player.x and player.x <= x1+width and
	   y1-height <= player.y and player.y <= y1+height then
	   return true
   end
   return false
end

function scene.spread_move(uid,package)
	local pid = pacakge.pid
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
					proto.sendpackage(obj.agent,package)
				elseif obj.police == POLICE_SEE_ALL then
					proto.sendpackage(obj.agent,package)
				end
			end
		end
	end
end

function command.move(pid,package)
	local player = scene.getplayer(pid)
	if not player then
		return
	end
	if not scene.canmove(pid) then
		return
	end
	local srcpos = package.srcpos	
	local dstpos = package.dstpos
	player.x = srcpos.x
	player.y = srcpos.y
	player.dir = srcpos.dir
	package.pid = pid
	for uid,obj in pairs(scene.players) do
		if player.teamid then
			if obj.teamid == player.teamid then
				if player.teamstate == TEAM_STATE_CAPTAIN then
					obj.x = player.x
					obj.y = player.y
					obj.dir = player.dir
					if obj.agent then
						proto.sendpackage(obj.agent,package)
					end
				else -- TEAM_STATE_LEAVE
					scene.spread_move(uid,package)
				end
			else
				scene.spread_move(uid,package)
			end
		else
			scene.spread_move(uid,package)
		end
	end
end

skynet.init(function ()
	skynet.dispatch("lua",function (session,source,cmd,...)

	end)
end)
