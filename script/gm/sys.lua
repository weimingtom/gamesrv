gm = require "script.gm.init"
require "script.oscmd.maintain"

--- cmd: maintain
--- usage: maintain shutdown_time
function gm.maintain(args)
	local isok,args = checkargs(args,"int")	
	if not isok then
		return "usage: maintain shutdown_time"
	end
	local lefttime = table.unpack(args)
	lefttime = math.max(0,math.min(lefttime,300))
	maintain.force_maintain(lefttime)
end

--- cmd: shutdown
--- usage: shutdown
function gm.shutdown(args)
	local reason = args[1] or "gm"
	game.shutdown(reason)
end

function gm.saveall(args)
	game.saveall()
end

--- cmd: kick
function gm.kick(args)
	local isok,args = checkargs(args,"int","*")	
	if not isok then
		return "usage: kick pid1 pid2 ..."
	end
	for i,v in ipairs(args) do
		local pid = tonumber(v)
		playermgr.kick(pid,"gm")
	end
end

--- cmd: kickall
function gm.kickall(args)
	playermgr.kickall(pid,"gm")
end

--- cmd: reloadproto
function gm.reloadproto(args)
	proto.reloadproto()
end

--- cmd: runcmd
--- usage: runcmd lua脚本 [是否返回结果]
function gm.runcmd(args)
	local cmdline = args[1]
	local noresult = args[2]
	if not noresult then
		cmdline = "return " .. cmdline
	end
	func = load(cmdline,"=(load)","bt")
	local result= func()
	return result
end

--- cmd: offline
--- usage: offline 玩家ID 指令 参数
function gm.offline(args)
	local isok,args = checkargs(args,"int","*")
	if not isok then
		return "usage: offline 玩家ID 指令 参数"
	end
	local pid = table.remove(args,1)
	local player = playermgr.loadofflineplayer(pid)
	if not player then
		return "Unknow pid:" .. tostring(pid)
	end
	local cmdline = table.concat(args," ")
	return gm.docmd(pid,cmdline)
end

--- cmd: hotfix
--- usage: hotfix 模块名...
function gm.hotfix(args)
	for i,modname in ipairs(args) do
		hotfix.hotfix(modname)
	end
end

--- cmd: countonline
function gm.countonline(args)
	local onlinenum,num = 0,0
	for pid,obj in pairs(playermgr.id_obj) do
		num = num + 1
		if obj.__type and obj.__type.__name == "cplayer" then
			onlinenum = onlinenum + 1
		end
	end
	return string.format("onlinenum:%s/%s,num:%s/%s",onlinenum,playermgr.onlinenum,num,playermgr.num)
end

return gm
