-- [10000,10100)
local proto = {}
proto.c2s = [[
test_handshake 10000 {
	response {
		msg 0 : string
	}
}

test_get 10001 {
	request {
		what 0 : string
	}
	response {
		result 0 : string
	}
}

test_set 10002 {
	request {
		what 0 : string
		value 1 : string
	}
}
]]

proto.s2c = [[
test_heartbeat 10000 {
}
]]

return proto
