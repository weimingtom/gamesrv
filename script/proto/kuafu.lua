-- [1100,1200)
local proto = {}
proto.c2s = [[
gosrv 1100 {
	request {
		go_srvname 0 : string
	}
}

gohome 1101 {
	request {
	}
}
]]

proto.s2c = [[
]]

return proto
