
ccardbaglib = class("ccardbaglib",ccontainer)

function ccardbaglib:init(conf)
	ccontainer.init(self,conf)
	self.sid_id = {}  -- 卡包类型：卡包ID
end

function ccardbaglib:load(data)
	if not data or not next(data) then
		return
	end
	ccontainer.load(self,data,function (cardbagdata)
		local cardbag = ccardbag.create({
			sid = cardbagdata.sid,
			pid = self.pid,
		})
		cardbag:load(cardbagdata)
		return cardbag
	end)
end

function ccardbaglib:save()
	return ccontainer.save(self,function (cardbag)
		return cardbag:save()
	end)
end

function ccardbaglib:clear()
	ccontainer.clear(self)
end

function ccardbaglib:onadd(cardbag)
	self.sid_id[cardbag.sid] = cardbag.id
end

function ccardbaglib:ondel(cardbag)
	self.sid_id[cardbag.sid] = nil
end

function ccardbaglib:newcardbag(sid)
	return ccardbag.create({
		pid = self.pid,
		sid = sid,
	})
end

function ccardbaglib:getcardbag(sid)
	local id = self.sid_id[sid]
	if id then
		return self:get(id)
	end
end

--/*
--增加卡包数量
--*/
function ccardbaglib:addcardbag(sid,num,reason)
	local cardbag = self:getcardbag(sid)
	if not cardbag then
		cardbag = self:newcardbag(sid)
		local id = self:genid()
		logger.log("info","cardbag",string.format("add,pid=%s id=%s sid=%s reason=%s",self.pid,id,sid,reason))
		self:add(cardbag,id)
	end
	logger.log("info","cardbag",string.format("addcardbag,pid=%s id=%s sid=%s num=%s reason=%s",self.pid,cardbag.id,sid,num,reason))
	cardbag.amount = cardbag.amount + num
end

--/*
--扣除卡包数量
--*/
function ccardbaglib:removecardbag(sid,num,reason)
	local cardbag = self:getcardbag(sid)
	assert(cardbag.amount >= num)
	logger.log("info","cardbag",string.format("removecardbag,pid=%s id=%s sid=%s num=%s reason=%s",self.pid,cardbag.id,sid,num,reason))
	cardbag.amount = cardbag.amount - num
	if cardbag.amount <= 0 then
		logger.log("info","cardbag",string.format("del,pid=%s id=%s sid=%s reason=%s",self.pid,cardbag.id,cardbag.sid,reason))
		self:del(cardbag.id)
	end
end

return ccardbaglib
