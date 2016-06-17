-- [800,900)

local proto = {}
proto.c2s = [[

team_createteam 800 {
	request {
		target 0 : integer
		stage 1 : integer # 阶段(目标详情)
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
}

team_apply_become_captain 808 {
}

team_agree_jointeam 809 {
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


#请求同步一个队伍数据
team_syncteam 812 {
	request {
		teamid 0 : integer
	}
}

team_openui_team 813 {
	request {
	}
}

team_automatch 814 {
	request {
		target 0 : integer
		stage 1 : integer
	}
}

team_unautomatch 815 {
	request {
	}
}

team_changetarget 816 {
	request {
		target 0 : integer
		stage 1 : integer
	}
}

team_apply_jointeam 817 {
	request {
		teamid 0 : integer
	}
}

team_delapplyers 818 {
	request {
		pids 0 : *integer # 发空表示清空所有申请者
	}
}
]]

proto.s2c = [[
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
		captain 4 : MemberType
	}
}

team_syncteam 805 {
	request {
		team 0 : TeamType
	}
}

team_addapplyer 806 {
	request {
		.TeamApplyerType {
			pid 0 : integer
			name 1 : string
			lv 2 : integer
			roletype 3 : integer
		}
		applyers 0 : *TeamApplyerType
	}
}

team_delapplyer 807 {
	request {
		applyers 0 : *integer
	}
}

team_openui_team 808 {
	request {
		teams 0 : *TeamType
		automatch 1 : boolean
	}
}


]]

return proto
