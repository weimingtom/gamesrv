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
		cardid 0 : integer
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
		attackerid 0 : integer
		defenserid 1 : integer
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

.BuffType {
	srcid 0 : integer	# 来源卡片ID
	srcsid 1 : integer	# 来源卡片SID
	.Buff {
		addmaxhp 0 : integer
		addatk 1 : integer
		setmaxhp 2 : integer
		setatk 3 : integer
		lifecircle 4 : integer
	}
	value 2 : Buff
}

.HaloType {
	srcid 0 : integer	# 来源卡片ID
	srcsid 1 : integer	# 来源卡片SID
	.Halo {
		addmaxhp 0 : integer
		addatk 1 : integer
		addcrystalcost 2 : integer
		setcrystalcost 3 : integer
		mincrystalcost 4 : integer
		lifecircle 5 : integer
	}
	value 2 : Halo
}

.LRHaloType {
	addmaxhp 0 : integer
	addatk 1 : integer
}

.StateType {
	assault 0 : integer
	sneer 1 : integer
	shield 2 : integer
	magic_immune 3 : integer
	freeze 4 : integer
	enrage 5 : integer
}

.WarCardType {
	id 0 : integer
	maxhp 1 : integer
	atk 2 : integer
	hp 3 : integer
	atkcnt 4 : integer
	leftatkcnt 5 : integer
	state 6 : StateType
	sid 7 : integer
	pos 8 : integer
	magic_hurt_adden 9 : integer
}

.WeaponType {
	id 0 : integer
	sid 1 : integer
	atk 2 : integer
	usecnt 3 : integer
	atkcnt 4 : integer
}

.EffectType {
	id 0 : integer
	sid 1 : integer
}

.ArgType {
	id 0 : integer
	pos 1 : integer
	warcard 2 : WarCardType
	attacker 3 : integer
	defenser 4 : integer
	sid 5 : integer
	value 6 : integer
	buff 7 : BuffType
	halo 8 : HaloType
	type 9 : string
	weapon 10 : WeaponType
	targetid 11 : integer
	srcid 12 : integer
	sids 13 : *integer
	lrhalo 14 : LRHaloType
	effect 15 : EffectType
}

# addbuff {id=integer,buff=BuffType}
# delbuff {id=integer,srcid=integer}
# addhalo {id=integer,halo=HaloType}
# delhalo {id=integer,srcid=integer}
# setmaxhp {id=integer,value=integer}
# setatk {id=integer,value=integer}
# setcrystalcost {id=integer,value=integer}
# sethp {id=integer,value=integer}
# silence {id=integer,pos=integer}
# syncard {warcard=WarCardType}
# delweapon {id=integer}
# equipweapon {id=integer,weapon=WeaponType}
# setweaponusecnt {id=integer,value=integer}
# setweaponatk {id=integer,value=integer}
# useskill {id=integer,targetid=integer}
# putinwar {pos=integer,warcard=WarCardType}
# removefromwar {id=integer}
# 对于奥秘牌，sid为0
# playcard {id=integer,sid=integer,pos=integer,targetid=integer}
# launchattack {id=integer,targetid=integer}
# putinhand {id=integer,sid=integer,pos=integer}
# removefromhand {id=integer}
# addsecret {id=integer}
# delsecret {id=integer}
# setcrystal {value=integer}
# set_empty_crystal {value=integer}
# setstate {id=integer,type=string,value=integer}
# delstate {id=integer,type=string}
# puttocardlib {id=integer}
# destroycard {sid=integer}
# setdef {id=integer,value=integer}
# set_cure_multiple {value=integer}
# set_magic_hurt_multiple {value=integer}
# set_hero_hurt_multiple {value=integer}
# set_cure_to_hurt {value=integer}
# set_magic_hurt_adden {value=integer}
# set_card_magic_hurt_adden {id=integer,value=integer}
# lookcards {sids=*integer}
# lookcards_discard {pos=integer}
# clearhandcard {}
# setlrhalo {id=integer,lrhalo=LRHaloType,}
# cancelchoice {id=integer}
# addeffect {id=integer,type=string,effect=EffectType}
# deleffect {id=integer,type=string,srcid=integer}

.CmdType {
	pid 0 : integer
	cmd 1 : string
	args 2 : ArgType
}

war_sync 505 {
	request {
		cmds 0 : *CmdType
	}
}
]]

return proto
