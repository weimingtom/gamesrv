require "script.playermgr"

loginqueue = loginqueue or {}

function loginqueue.init()
	loginqueue.queue = {}
end

function loginqueue.push(info,pos)
	if pos then
		table.insert(loginqueue.queue,pos,info)
	else
		table.insert(loginqueue.queue,info)
	end
end

function loginqueue.pop()
	if loginqueue.len() > 0 then
		local v = loginqueue.queue[1]
		local pid,roleid = v.pid,v.roleid
		table.remove(loginqueue.queue,1)
		local obj = playermgr.getobject(pid)
		if obj then
			local player = playermgr.recoverplayer(roleid)
			playermgr.transfer_mark(obj,player)
			playermgr.nettransfer(obj,player)
			player:entergame()
		end
	end
end

function loginqueue.remove(pid)
	for i,v in ipairs(loginqueue.queue) do
		if v.pid == pid then
			table.remove(loginqueue.queue,i)
			break
		end
	end
end

function loginqueue.len()
	return #loginqueue.queue
end

return loginqueue
