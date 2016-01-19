local protomods = {
	"friend",
	"login",
	"msg",
	"player",
	"war",
	"test",
	"mail",
	"card",
	"team",
	"scene",
}

local proto = {}

function proto.init()
	proto.s2c = [[
.package {
	type 0 : integer
	session 1 : integer
}
]]
	proto.c2s = [[
.package {
	type 0 : integer
	session 1 : integer
}
]]
	local data = require "script.proto.type"
	proto.s2c = proto.s2c .. data.s2c
	proto.c2s = proto.c2s .. data.c2s
	for _,modname in ipairs(protomods) do
		local data = require("script.proto." .. modname)
		proto.s2c = proto.s2c .. data.s2c
		proto.c2s = proto.c2s .. data.c2s
	end
end

proto.init()

function proto.dump()
	local fd = io.open("../script/proto/proto_c2s.txt","wb")	
	fd:write(proto.c2s)
	fd:close()
	local fd = io.open("../script/proto/proto_s2c.txt","wb")	
	fd:write(proto.s2c)
	fd:close()
end

return proto
