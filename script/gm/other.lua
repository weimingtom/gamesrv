
gm = require "script.gm"
require "script.net"

--- usage: echo msg
function gm.echo(args)
	local ok,result = checkargs(args,"string")
	if not ok then
		net.msg.notify(master.pid,"usage: echo msg")
		return
	end
	local msg = table.unpack(result)
	print("length:",#msg,msg)
	net.msg.notify(master.pid,msg)
end

return gm
