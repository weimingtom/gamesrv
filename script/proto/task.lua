-- [1000,1100)
local proto = {}
proto.c2s = [[
task_accepttask 1000 {
	request {
		# <10000--任务类型,>=10000--任务ID
		taskid 0 : integer
	}
}

task_submittask 1001 {
	request {
		taskid 0 : integer
	}
}

task_giveuptask 1002 {
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
		task 0 : TaskType
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
		task 0 : TaskType
	}
}

task_circle 10003 {
	request {
		circle 0 : TaskCircle
	}
}
]]

return proto
