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

do
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
	proto.c2s = proto.c2s ..data.c2s
	for _,modname in ipairs(protomods) do
		local data = require("script.proto." .. modname)
		proto.s2c = proto.s2c .. data.s2c
		proto.c2s = proto.c2s .. data.c2s
	end
end

function proto.dump(text_proto)
	text_proto = text_proto or proto
	local lineno
	local b,e
	print("s2c:")
	lineno = 1
	b = 1
	while true do
		e = string.find(text_proto.s2c,"\n",b)
		if not e then
			break
		end
		print(lineno,string.sub(text_proto.s2c,b,e-1))
		b = e + 1
		lineno = lineno + 1
	end
	print("c2s:")
	lineno = 1
	b = 1
	while true do
		e = string.find(text_proto.c2s,"\n",b)
		if not e then
			break
		end
		print(lineno,string.sub(text_proto.c2s,b,e-1))
		b = e + 1
		lineno = lineno + 1
	end
end

return proto
