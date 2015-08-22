-- [200,300)
local proto = {}
proto.c2s = [[
player_gm 200 {
	request {
		cmd 0 : string
	}
}

player_enter 201 {
	request {
		what 0 : string
	}
}
]]

proto.s2c = [[
player_heartbeat 200 {
	request {
		msg 0 : string
	}
}

player_resource 201 {
	request {
		gold 0 : integer
		chip 1 : integer
	}
}

player_switch 202 {
	request {
		gm 0 : boolean
		friend 1 : boolean
	}
}

]]

return proto
