-- [900,1000)
local proto = {}
proto.c2s = [[
scene_move 900 {
	request {
		srcpos 0 : PosType
		dstpos 1 : PosType
		time 2 : integer #发包时间
	}
}

scene_stop 901 {
	request {
	}
}

# 定时同步位置
scene_setpos 902 {
	request {
		pos 0 : PosType
	}
}

scene_enter 903 {
	request {
		sceneid 0 : integer
		pos 1 : PosType
	}
}
]]

proto.s2c = [[
scene_move 900 {
	request {
		pid 0 : integer
		srcpos 1 : PosType
		dstpos 2 : PosType
		time 3 : integer
	}
}

scene_stop 901 {
	request {
		pid 0 : integer
	}
}


scene_enter 902 {
	request {
		pid 0 : integer
		resume 1 : ResumeType
	}
}

scene_exit 903 {
	request {
		pid 0 : integer
	}
}

# 更新玩家的场景信息（不包括位置)
scene_update 904 {
	request {
		pid 0 : integer
		resume 1 : ResumeType
	}
}

scene_setpos 905 {
	request {
		pid 0 : integer
		pos 1 : PosType
	}
}
]]

return proto
