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

team_publishteam 800 {
	request {
		teamid 0 : integer
		time 1 : integer
		target 2 : integer
		taskid 3 : integer
		members 4 : *MemberType
	}
}

team_member 801 {
	request {
		teamid 0 : integer
		member 1 : MemberType
	}
}

team_addapplyer 802 {
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

team_delapplyer 803 {
	request {
		applyers : *integer
	}
}
]]

return proto
