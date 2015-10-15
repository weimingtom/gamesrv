-- [900,1000)
local proto = {}
proto.c2s = [[
.PosType {
	x 0 : integer
	y 1 : integer
	dir 2 : integer
}

scene_move 900 {
	request {
		srcpos 0 : PosType
		dstpos 1 : PosType
		time 2 : integer #发包时间
	}
}

scene.stop 901 {
	request {
	}
}

# 定时同步位置
scene_setpos 902 {
	request {
		pos 0 : PosType
	}
}

scene.enter 903 {
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

.ResumeType {
	name 0 : string
	roletype 1 : integer
	lv 2 : integer
	teamid 3 : integer
	state 4 : integer
	warstate 5 : integer
	x 6 : integer
	y 7 : integer
	dir 8 : integer
	v 9 : integer # 速度
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
