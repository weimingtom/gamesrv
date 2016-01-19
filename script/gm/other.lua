
gm = require "script.gm.init"

--- cmd: echo
--- usage: echo msg
function gm.echo(args)
	local isok,args = checkargs(args,"string")
	if not isok then
		net.msg.notify(master.pid,"usage: echo msg")
		return
	end
	local msg = table.unpack(args)
	print("length:",#msg,msg)
	net.msg.notify(master.pid,msg)
end

return gm
