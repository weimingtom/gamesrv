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

