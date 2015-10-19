-- [1,100)
local proto = {}
proto.c2s = [[
login_register 1 {
	request {
		account 0 : string
		passwd 1 : string
		srvname 2 : string
	}
	response {
		# see errcode.lua
		result 0 : integer
	}
}


login_createrole 2 {
	request {
		account 0 : string
		roletype 1 : integer
		name 2 : string
	}
	response {
		# see errcode.lua
		result 0 : integer
		newrole 1 : RoleType
	}
}



login_login 3 {
	request {
		account 0 : string
		passwd 1 : string
	}
	response {
		# see errcode.lua
		result 0 : integer
		roles 1 : *RoleType
	}
}


login_entergame 4 {
	request {
		roleid 0 : integer
	}
	response {
		# see errcode.lua
		result 0 : integer
	}
}

login_exitgame 5 {
}
]]

proto.s2c = [[
login_kick 1 {
	request {
		reason 0 : string
	}
}

login_queue 2 {
	request {
		waitnum 0 : integer
	}
}

login_reentergame 3 {
	request {
		srvname 0 : string
		token 1 : string
	}
}
]]

return proto
