-- [1000,1100)
local proto = {}
proto.c2s = [[
task_accepttask 1000 {
	request {
		taskid 0 : integer
	}
}
]]

proto.s2c = [[
-- 不同任务，data数据格式不同,
-- 对于收集物品任务:{progress=进度,}
task_addtask 1000 {
	request {
		taskid 0 : integer
		state 1 : integer #1--接受状态,2--完成状态
		data 2 : string #需要用json解包
	}
}

task_deltask 1001 {
	request {
		taskid 0 : integer
	}
}

task_finishtask 1002 {
	request {
		taskid 0: integer
	}
}

task_updatetask 10002 {
	request {
		taskid 0 : integer
		state 1 : integer #1--接受状态,2--完成状态
		data 2 : string #需要用json解包
	}
}

task_circle 10003 {
	request {
		circle 0 : TaskCircle
	}
}
]]

return proto
