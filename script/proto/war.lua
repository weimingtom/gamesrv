-- [500,700)
local proto = {}
proto.c2s = [[
war_selectcardtable 500 {
	request {
		# fight; arena; entertainment
		type 0 : string
		cardtableid 1 : integer
		
	}
}

war_search_opponent 501 {
	request {
		# fight; arena; entertainment
		type 0 : string
	}
}

war_confirm_handcard 502 {
	request {
		# 放弃的手牌
		poslist 0 : *integer
	}
}

war_playcard 503 {
	request {
		id 0 : integer
		pos 1 : integer
		targetid 2 : integer
		choice 3 : integer
	}
}

war_endround 504 {
	request {
		roundcnt 0 : integer
	}
}

war_launchattack 505 {
	request {
		id 0 : integer
		targetid 1 : integer
	}
}

war_hero_useskill 506 {
	request {
		targetid 0 : integer
	}
}

war_giveupwar 507 {
	request {
	}
}

war_lookcards_confirm 508 {
	request {
		pos 0 : integer
	}
}

]]

proto.s2c = [[
war_startwar 500 {
	request {
		warid 0 : integer
	}
}


war_warresult 501 {
	request {
		warid 0 : integer
		result 1 : integer
	}
}
war_beginround 502 {
	request {
		roundcnt 0 : integer
	}
}

war_endround 503 {
	request {
		roundcnt 0 : integer
	}
}

war_matchplayer 504 {
	request {
		pid 0 : integer
		race 1 : integer
		name 2 : string
		lv 3 : integer
		photo 4 : integer
		# 显示的成就列表
		show_achivelist 5 : *integer
		isattacker 6 : boolean
	}
}


war_sync 505 {
	request {
		cmds 0 : *CmdType
	}
}
]]

return proto
