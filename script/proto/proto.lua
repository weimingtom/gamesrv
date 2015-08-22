local protomods = {
	"friend",
	"login",
	"msg",
	"player",
	"war",
	"test",
	"mail",
	"card",
}

local proto = {}

local function init()
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
	for _,modname in ipairs(protomods) do
		local data = require("script.proto." .. modname)
		proto.s2c = proto.s2c .. data.s2c
		proto.c2s = proto.c2s .. data.c2s
	end
end

init()
return proto
