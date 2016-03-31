-- 当前范围:[1,1200)
local proto = {}
proto.c2s = [[
.RoleType {
	roleid 0 : integer
	roletype 1 : integer
	name 2 : string
	lv 3 : integer
}

.ResOrItemType {
	type 0 : integer #资源类型/物品类型
	num 1 : integer
}

.MailType {
	mailid 0 : integer
	sendtime 1 : integer
	author 2 : string
	title 3 : string
	content 4 : string
	attach 5 : *ResOrItemType
	readtime 6 : integer
	srcid 7 : integer #邮件来源ID（0--系统，其他--玩家ID)
	pid 8 : integer  # 邮件拥有者ID(可能没用)
}

.PosType {
	x 0 : integer
	y 1 : integer
	dir 2 : integer
}

.ResumeType {
	name 0 : string
	roletype 1 : integer
	lv 2 : integer
	teamid 3 : integer
	state 4 : integer
	warstate 5 : integer
	pos 6: PosType
	v 7 : integer # 速度
}


.MemberType {
	pid 0 : integer
	name 1 : string
	lv 2 : integer
	roletype 3 : integer
	# 1--captain, 2--follow member,3--leave member,4--offline member
	state 4 : integer
}

.TeamType {
	teamid 0 : integer
	target 1 : integer
	# 组队目标详情/阶段
	stage 2 : integer
	members 3 : *MemberType
	automatch 4 : boolean
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

.TaskCircle {
	shimen 0 : integer #师门环数
}

.TaskType {
	taskid 0 : integer
	state 1 : integer #1--接受状态，2--完成状态该
	data 2 : string #需要用json解包
}
]]

proto.s2c = proto.c2s

return proto

