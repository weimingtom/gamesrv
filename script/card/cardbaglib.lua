require "script.logger"

ccardbaglib = class("ccardbaglib",cdatabaseable)

function ccardbaglib:init(pid)
	self.flag = "ccardbaglib"
	cdatabaseable.init(self,{
		pid = pid,
		flag = self.flag,
	})
	self.data = {}
	self.cardbags = {}
end

function ccardbaglib:load(data)
	if not data or not next(data) then
		return
	end
	self.data = data.data
	for id,num in pairs(data.cardbags) do
		id = tonumber(id)
		self.cardbags[id] = num
	end
end

function ccardbaglib:save()
	local data = {}
	data.data = self.data
	local cardbags = {}
	for id,num in pairs(self.cardbags) do
		id = tostring(id)
		cardbags[id] = num
	end
	data.cardbags = cardbags
	return data
end

function ccardbaglib:isvalidid(id)
	return 1 <= id and id <= 2
end

function ccardbaglib:addcardbag(id,num,reason)
	logger.log("info","cardbag",string.format("addcardbag,pid=%d id=%d num=%d reason=%s",self.pid,id,num,reason))
	self.cardbags[id] = (self.cardbags[id] or 0) + num
	return num
end

function ccardbaglib:getcardbagnum(id)
	return self.cardbags[id] or 0
end

return ccardbaglib
