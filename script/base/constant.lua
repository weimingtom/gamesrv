-- team
NO_TEAM						= 0
TEAM_CAPTAIN				= 1
TEAM_STATE_FOLLOW			= 2
TEAM_STATE_LEAVE			= 3
TEAM_STATE_OFFLINE			= 4
TEAM_STATE_ALL				= 5

ANY_TARGET					= 0
ANY_STAGE					= 0

-- messagebox
MB_RECALLMEMBER				= 1
MB_INVITE_JOINTEAM			= 2
MB_APPLY_BECOME_CAPTAIN		= 3

-- war
NOWAR						= 0
INWAR						= 1

-- 场景
POLICE_SEE_ALL			= 1 -- 看到所有人
POLICE_SEE_CAPTAIN		= 2 -- 只能看到队长/暂离玩家/散人
POLICE_SEE_SELF			= 3 -- 只能看到自身队伍/自己

DEFAULT_SCENEID			= 1 -- 默认场景
DEFAULT_POS				= { -- 默认位置
	x = 100,
	y = 100,
	dir = 1,
}

DEFAULT_SEEN = {
	width = 920,
	height = 860,
}

BORN_SCENEID = 1 -- 出生场景
ALL_BORN_LOCS = { -- 出生位置
	{x=10,y=10,dir=1},
	{x=20,y=20,dir=1},
	{x=30,y=30,dir=1},
}

-- 资源
MAX_RESTYPE = 1000 -- 最大资源类型

RESTYPE_GOLD = 1  -- 金币
RESTYPE_CHIP = 2  -- 粉尘


-- 任务
TASK_STATE_ACCEPT = 1 -- 接受
TASK_STATE_FINISH = 2 -- 完成


TASK_TYPE_NAME = {}
function settaskname(tasktype,name)
	TASK_TYPE_NAME[tasktype] = name
	TASK_TYPE_NAME[name] = tasktype
end
TASK_TYPE_MAIN		= 1 --主线
TASK_TYPE_BRANCH	= 2 --支线
TASK_TYPE_SHIMEN	= 3 --师门
settaskname(TASK_TYPE_MAIN,"zhuxian")
settaskname(TASK_TYPE_BRANCH,"zhixian")
settaskname(TASK_TYPE_SHIMEN,"shimen")

-- system
NORET = NORET or {}
