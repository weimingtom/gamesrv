-- [300,400)
local proto = {}
proto.c2s = [[
friend_apply_addfriend 300 {
	request {
		pid 0 : integer
	}
}

friend_agree_addfriend 301 {
	request {
		pid 0 : integer
	}
}

friend_reject_addfriend 302 {
	request {
		pid 0 : integer
	}
}

friend_delfriend 303 {
	request {
		pid 0 : integer
	}
}

friend_sendmsg 304 {
	request {
		pid 0 : integer
		msg 1 : string
	}
}


]]

proto.s2c = [[
friend_sync 300 {
	request {
		srvname 0 : string
		name 1 : string
		roletype 2 : integer
		lv 3 : integer
	}
}

friend_addlist 301 {
	request {
		pids 0 : *integer
		# 0--applyer; 1--friend; 2--toapply
		type 1 : integer
		# true--新增,false--原有列表
		newflag 2 : boolean
	}
}

friend_dellist 302 {
	request {
		pids 0 : *integer
		# 0--applyer; 1--friend; 2--toapply
		type 1 : integer
	}
}

friend_addmsgs 303 {
	request {
		pid 0 : integer
		msgs 1 : *string
	}
}

]]

return proto
