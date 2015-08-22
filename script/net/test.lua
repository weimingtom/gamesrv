

nettest = nettest or {}

-- c2s
local REQUEST = {} 
nettest.REQUEST = REQUEST
function REQUEST.handshake(player)
	return {msg = "Welcome to skynet server"}
end

function REQUEST.get(player,request)
	-- simple echo
	return {result = request.what}
end

function REQUEST.set(player,request)
end


local RESPONSE = {}
nettest.RESPONSE = RESPONSE
function RESPONSE.handshake(player,request,response)
end

function RESPONSE.get(player,request,response)
end

-- s2c
function nettest.heartbeat(pid)
end
return nettest
