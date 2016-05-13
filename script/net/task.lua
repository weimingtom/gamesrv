nettask = nettask or {}

-- c2s
local REQUEST = {} 
nettask.REQUEST = REQUEST

function REQUEST.accepttask(player,request)
	local pid = player.pid
	local taskid = request.taskid
	local isok,msg = player.taskdb:canaccepttask(taskid)
	if not isok then
		if msg then
			net.msg.notify(player,msg)
		end
		return
	end
	player.taskdb:accepttask(taskid)
end

function REQUEST.finishtask(player,request)
	local taskid = request.taskid
	local taskdb = player.taskmgr:gettaskdb_by_taskid(taskid)
	local taskdata = taskdb:gettaskdata(taskid)
	if not taskdata.client_canfinish then
		return
	end
	local task = player.taskdb:gettask(taskid)
	if not task then
		return
	end
	player.taskdb:finishtask(task)
end

function REQUEST.submittask(player,request)
	local pid = player.pid
	local taskid = request.taskid
	local task = player.taskdb:gettask(taskid)
	if not task then
		return
	end
	local isok,msg = player.taskddb:cansubmittask(taskid)
	if not isok then
		if msg then
			net.msg.notify(pid,msg)
		end
		return
	end
	player.taskdb:submittask(task)
end

function REQUEST.giveuptask(player,request)
	local pid = player.pid
	local taskid = request.taskid
	local task = player.taskddb:gettask(taskid)
	if not task then
		sendpackage(pid,"task","deltask",{taskid=taskid})
		return
	end
	local isok,msg = player.taskdb:cangiveuptask(taskid)
	if not isok then
		if msg then
			net.msg.notify(pid,msg)
		end
		return
	end
	player.taskdb:giveuptask(task)
end

local RESPONSE = {}
nettask.RESPONSE = RESPONSE

-- s2c
return nettask
