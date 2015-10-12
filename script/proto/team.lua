-- [800,900)
local proto = {}
proto.c2s = [[
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
		automatch 2 : boolean
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

team_syncteam 812 {
	request {
		teamid 0 : integer
	}
}

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
	member 3 : MemberType,
}

team_openui_team 813 {
	request {
	}
	response {
		teams 0 : *TeamType
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
	member 3 : MemberType,
}

team_selfteam 800 {
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
	}
}

team_syncteam 805 {
	request {
		team 0 : TeamType
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
