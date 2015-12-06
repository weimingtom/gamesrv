local sprotoloader = require "sprotoloader"
local proto = require "script.proto.proto"
local skynet = require "script.skynet"
local sprotoparser = require "sprotoparser"

skynet.start(function ()
	proto.init()
	proto.dump()
	local bin_c2s = sprotoparser.parse(proto.c2s)
	local bin_s2c = sprotoparser.parse(proto.s2c)
	sprotoloader.save(bin_c2s,1)
	sprotoloader.save(bin_s2c,2)
	-- don't call skynet.exit() , because sproto.core may unload and the global slot become invalid
end)


