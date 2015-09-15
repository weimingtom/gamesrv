gm = require "script.gm.init"
require "script.oscmd.maintain"

--- usage: maintain shutdown_time
function gm.maintain(args)
	local ok,result = checkargs(args,"int")	
	if not ok then
		net.msg.notify(master.pid,"usage: maintain shutdown_time")
		return
	end
	local lefttime = tonumber(args[1])
	lefttime = math.max(0,math.min(lefttime,300))
	maintain.force_maintain(lefttime)
end

--- usage: shutdown
function gm.shutdown(args)
	local reason = args[1] or "gm"
	game.shutdown(reason)
end

return gm
