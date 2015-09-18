-- [800,900)
local proto = {}
proto.c2s = [[
team_createteam 800 {
}

team_dismissteam 801 {
}

team_publishteam 802 {
	request {
		target 0 : integer
		automatch 1 : boolean
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
}
]]

proto.s2c = [[
]]

return proto
