ccardbag = class("ccardbag")

function ccardbag:init(conf)
	self.pid = assert(conf.pid)
	self.sid = assert(conf.sid)
	self.id = nil -- 开包ID，加入容器后初始化
	self.amount = 0
end

function ccardbag:load(data)
	if not data or not next(data) then
		return
	end
	self.id = data.id
	self.sid = data.sid
	self.amount = data.amount
end

function ccardbag:save()
	local data  = {}
	data.id = self.id
	data.sid = self.sid
	data.amount = self.amount
	return data
end

function getcardbagcls(sid)
	require "script.cardbag.cardbagmodule"
	return cardbagmodule[sid]
end

function ccardbag.create(conf)
	local sid = assert(conf.sid)
	local cardbagcls = getcardbagcls(sid)
	return cardbagcls.new(conf)
end

return ccardbag
