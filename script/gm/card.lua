
gm = require "script.gm.init"

--- cmd: addcard
--- e.g.:  addcard 10001 11001 10
function gm.addcard(args)
	local isok,args = checkargs(args,"int","int","int")
	if not isok then
		net.msg.notify(master_pid,"usage: addcard sid amount")	
		return
	end
	local pid,sid,amount = table.unpack(args)
	local player = playermgr.getplayer(pid)
	if not player then
		net.msg.notify(master_pid,string.format("player(%d) not online",pid))
		return
	end
	player:addcardbysid(sid,amount)
end

--- cmd: delcard
--- usage: delcard pid sid amount
--- e.g. : delcard 10001 11001 10
function gm.delcard(args)
	local isok,args = checkargs(args,"int","int","int")	
	if not isok then
		net.msg.notify(master_pid,"usage: delcard pid sid amount")
		return
	end
	local pid,sid,amount = table.unpack(args)
	local player = playermgr.getpalyer(pid)
	if not player then
		net.msg.notify(master_pid,string.format("player(%d) not online",pid))
		return
	end
	player:delcardbysid(sid,amount)
end

--- cmd: clearcard
--- usage: clearcard pid racename
--- e.g. : clearcard 10001 all
function gm.clearcard(args)
	local isok,args = checkargs(args,"int","string")
	if not isok then
		net.msg.notify(master_pid,"usage: clearcard pid")
		return
	end
	local pid,racename = table.unpack(args)
	local player = playermgr.getplayer(pid)
	if not player then
		net.msg.notify(master_pid,string.format("player(%d) not online",pid))
		return
	end
	if racename == "all" then
		player.carddb:clear()
	else
		local carddb = player.carddb.getcarddb_byname(racename)
		carddb:clear()
	end
end

return gm
