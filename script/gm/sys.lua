gm = require "script.gm.init"
require "script.oscmd.maintain"

--- usage: maintain shutdown_time
function gm.maintain(args)
	local isok,args = checkargs(args,"int")	
	if not isok then
		net.msg.notify(master.pid,"usage: maintain shutdown_time")
		return
	end
	local lefttime = table.unpack(args)
	lefttime = math.max(0,math.min(lefttime,300))
	maintain.force_maintain(lefttime)
end

--- usage: shutdown
function gm.shutdown(args)
	local reason = args[1] or "gm"
	game.shutdown(reason)
end

function gm.saveall(args)
	game.saveall()
end

--- usage: kick pid1 pid2,...
function gm.kick(args)
	local isok,args = checkargs(args,"int","*")	
	if not isok then
		net.msg.notify(master.pid,"usage: kick pid1 pid2 ...")
		return
	end
	for i,v in ipairs(args) do
		local pid = tonumber(v)
		playermgr.kick(pid,"gm")
	end
end

--- usage: kickall
function gm.kickall(args)
	playermgr.kickall(pid,"gm")
end

--- usage: reloadproto
function gm.reloadproto(args)
	proto.reloadproto()
end

return gm
