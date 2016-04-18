ccarddb = class("ccarddb",ccontainer)

function ccarddb:init(param)
	self.name = assert(param.name)
	ccontainer.init(self,param)
	self.sid_id = {}
end

function ccarddb:load(data)
	if not data or not next(data) then
		return
	end
	ccontainer.load(self,data,function (carddata)
		local card = ccard.create({
			pid = self.pid,
			sid = carddata.sid,
		})
		card:load(carddata)
		return card
	end)
	for id,card in pairs(self.objs) do
		self.sid_id[card.sid] = id
	end
end

function ccarddb:save()
	return ccontainer.save(self,function (card)
		return card:save()
	end)
end

function ccarddb:clear()
	logger.log("info","card",string.format("[clear] name=%s pid=%s",self.name,self.pid))
	ccontainer.clear(self)
	self.sid_id = {}
end

function ccarddb:getcard(id)
	return self:get(id)
end

function ccarddb:getcardbysid(sid)
	local id = self.sid_id[sid]
	if id then
		return self:getcard(id)
	end
end

function ccarddb:addcard(card,reason)
	logger.log("info","card",string.format("[addcard] name=%s pid=%s id=%s sid=%s reason=%s",self.name,self.pid,card.id,card.sid,reason))
	self:__addcard(card)
end

function ccarddb:__addcard(card)
	local id = assert(card.id)
	local sid = assert(card.sid)
	assert(self:getcard(id)==nil)
	self.sid_id[sid] = id
	self:add(card,id)
end

function ccarddb:delcard(id,reason)
	local card = self:getcard(id)
	if not card then
		return
	end
	logger.log("info","card",string.format("[delcard] name=%s pid=%s id=%s sid=%s reason=%s",self.name,self.pid,id,card.sid,reason))
	self:del(id)
	self.sid_id[card.sid] = nil
	return card
end

function ccarddb:delcardbysid(sid,reason)
	local id = self.sid_id[sid]
	if id then
		return self:delcard(id,reason)
	end
end

return ccarddb
