--/*
-- 延迟到玩家下次登录执行的操作
--*/

cdelaytonextlogin = class("cdelaytonextlogin")

function cdelaytonextlogin:init(pid)
	self._self_call_onlogin = true -- 需要手动调用onlogin
	self.pid = pid
	self.queue = {}
end

function cdelaytonextlogin:load(data)
	if not data or not next(data) then
		return
	end
	self.queue = data.queue
end

function cdelaytonextlogin:save()
	local data = {}
	data.queue = self.queue
	return data
end

function cdelaytonextlogin:executex(cmd,...)
	local packfunc = pack_function(cmd,...)
	table.insert(self.queue,packfunc)
end

function cdelaytonextlogin:execute(cmd,...)
	local firstchar = string.char(string.byte(cmd,1,1))
	assert(firstchar=="." or firstchar == ":")
	cmd = string.format("playermgr.getplayer(%d)%s",self.pid,cmd)
	return self:executex(cmd,...)
end

function cdelaytonextlogin:entergame()
	local queue = self.queue
	self.queue = {}
	for i,packfunc in ipairs(queue) do
		local func = unpack_function(packfunc)
		xpcall(func,onerror)
	end
end

return cdelaytonextlogin
