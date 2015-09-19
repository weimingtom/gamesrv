-- [100,200)
local proto = {}
proto.c2s = [[
msg_onmessgebox 101 {
	request {
		id 0 : integer
		buttonid 1 : integer
	}
}
]]

proto.s2c = [[
msg_notify 100 {
	request {
		msg 0 : string
	}
}

msg_messagebox 101 {
	request {
		id 0 : integer # 0--no callback
		title 1 : string
		content 2 : string
		attach 3 : AttachType
		buttons 4 : *string
		type 5 : integer
	}
}

]]

return proto
