-- [800,900)
local proto = {}
proto.c2s = [[
.MemberType {
	pid 0 : integer
	name 1 : string
	lv 2 : integer
	roletype 3 : integer
	# 1--captain,2--follow member,3--leave member,  4--offline member
	state 4 : integer
}

.TeamType {
	teamid 0 : integer
	target 1 : integer
	# 组队目标详情/阶段
	stage 2 : integer
	members 3 : *MemberType
}

team_createteam 800 {
	request {
		target 0 : integer
		stage 1 : integer	# 阶段（目标详情)
	}
}

team_dismissteam 801 {
}

team_publishteam 802 {
	request {
		target 0 : integer
		stage 1 : integer
	}
}

team_jointeam 803 {
	request {
		teamid 0 : integer
	}
}

team_leaveteam 804 {
}

team_quitteam 805 {
}

team_backteam 806 {
}

team_recallmember 807 {
	request {
		pids 0 : *integer
	}
}

team_apply_become_captain 808 {
}

team_agree_become_captain 809 {
	request {
		pid 0 : integer
	}
}

team_changecaptain 810 {
	request {
		pid 0 : integer
	}
}

team_invite_jointeam 811 {
	request {
		pid 0 : integer
	}
}

# 同步/请求一个队伍数据
team_syncteam 812 {
	request {
		teamid 0 : integer
	}
	response {
		team 0 : TeamType
	}
}

# 打开组队平台
team_openui_team 813 {
	request {
		# {0}--任何组队目标，其他--特定组队目标
		target 0 : *integer
		stage 1 : *integer
	}
	response {
		teams 0 : *TeamType
	}
}

team_automatch 814 {
	request {
		# 0--取消自动匹配，1--自动匹配
		choose 0 : integer
	}
}
]]

proto.s2c = [[
.MemberType {
	pid 0 : integer
	name 1 : string
	lv 2 : integer
	roletype 3 : integer
	# 1--captain,2--follow member,3--leave member,  4--offline member
	state 4 : integer
}

.TeamType {
	teamid 0 : integer
	target 1 : integer
	# 组队目标详情/阶段
	stage 2 : integer
	members 3 : *MemberType
}

# 创建队伍
team_createteam 800 {
	request {
		team 0 : TeamType
	}
}

team_addmember 801 {
	request {
		teamid 0 : integer
		member 1 : MemberType
	}
}

team_updatemember 802 {
	request {
		teamid 0 : integer
		member 1 : MemberType
	}
}

team_delmember 803 {
	request {
		teamid 0 : integer
		pid 1 : integer
	}
}

team_publishteam 804 {
	request {
		teamid 0 : integer
		time 1 : integer
		target 2 : integer
		stage 3 : integer
		captain 4 : MemberType
	}
}


team_addapplyer 805 {
	.ResumeType {
		pid 0 : integer
		name 1 : string
		lv 2 : integer
		roletype 3 : integer
	}
	request {
		applyers 0 *Resumetype
	}
}

team_delapplyer 806 {
	request {
		applyers : *integer
	}
}

]]

return proto
