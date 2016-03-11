ccardlib = class("ccardlib")

function ccardlib:init(conf)
	self.pid = assert(conf.pid)
	self.loadstate = "unload"
	self.cardid = 0
	self.name_carddb = {}
	self:addcarddb(ccarddb.new{pid=self.pid,name="golden",})
	self:addcarddb(ccarddb.new{pid=self.pid,name="wood",})
	self:addcarddb(ccarddb.new{pid=self.pid,name="water",})
	self:addcarddb(ccarddb.new{pid=self.pid,name="fire",})
	self:addcarddb(ccarddb.new{pid=self.pid,name="soil",})
	self:addcarddb(ccarddb.new{pid=self.pid,name="neutral",})
end

--/*
--新增一个卡牌背包
--@note :所有卡牌背包中的卡牌都是共享ID(即可以保证唯一性)
--*/
function ccardlib:addcarddb(carddb)
	local name = assert(carddb.name)
	assert(self.name_carddb[name]==nil)
	self[name] = carddb
	self.name_carddb[name] = true
	return carddb
end

function ccardlib:getcarddb(name)
	assert(self.name_carddb[name]~=nil)
	return self[name]
end

function ccardlib:load(data)
	if not data or not next(data) then
		return
	end
	self.cardid = data.cardid
	for name,_ in pairs(self.name_carddb) do
		local carddb = self:getcarddb(name)
		carddb:load(data[name])
	end
end

function ccardlib:save()
	local data = {}
	data.cardid = self.cardid
	for name,_ in pairs(self.name_carddb) do
		local carddb = self:getcarddb(name)
		data[name] = carddb:save()
	end
end

function ccardlib:clear()
	for name,_ in pairs(self.name_carddb) do
		local carddb = self:getcarddb(name)
		carddb:clear()
	end
end

function ccardlib:gencardid()
	self.cardid = self.cardid + 1
	return self.cardid
end

function ccardlib:newcard(sid)
	require "script.card.init"
	local id = self:gencardid()
	return ccard.create({
		id = id,
		sid = sid,
		pid = self.pid,
	})
end

function ccardlib:getcard(id)
	for name,_ in pairs(self.name_carddb) do
		local carddb = self:getcarddb(name)
		local card = carddb:getcard(id)
		if card then
			return card
		end
	end
end

function ccardlib:getcardbysid(sid)
	for name,_ in pairs(self.name_carddb) do
		local carddb = self:getcarddb(name)
		local card = carddb:getcardbysid(sid)
		if card then
			return card
		end
	end
end

function ccardlib:addcard(card,reason)
	local race = card.race
	local racename = getracename(race)
	local carddb = self:getcarddb(racename)
	return carddb:addcard(card,reason)
end

function ccardlib:delcard(id,reason)
	for name,_ in pairs(self.name_carddb) do
		local carddb = self:getcarddb(name)
		local card = carddb:delcard(id,reason)
		if card then
			return card
		end
	end
end

function ccardlib:delcardbysid(sid,reason)
	for name,_ in pairs(self.name_carddb) do
		local carddb = self:getcarddb(name)
		local card = carddb:delcardbysid(sid,reason)
		if card then
			return card
		end
	end
end

function ccardlib:decompose(card,amount)
	local id = card.id
	local player = playermgr.getplayer(self.pid)
	amount = amount or 1
	local oldamount = card:get("amount")
	amount = math.min(amount,oldamount)
	local newamount = oldamount - amount
	local reason = "decompose"
	logger.log("info","card",string.format("decompose,pid=%s id=%s sid=%s amount=%s newamount=%s",self.pid,id,card.sid,amount,newamount))
	if newamount > 0 then
		card:set("amount",newamount)
	else
		self:delcard(id,reason)
	end
	local cardcls = getclassbycardsid(card.sid)
	local decomposechip = cardcls.decomposechip * amount
	player:addchip(decomposechip,reason)
end

function ccarddb:compose(sid)
	local player = playermgr.getplayer(self.pid)
	local cardcls = getclassbycardsid(sid)
	local composechip = cardcls.composechip
	if not player:validpay("chip",composechip) then
		return
	end
	local reason = "compose"
	player:addchip(-composechip,reason)
	local card = self:getcardbysid(sid)
	if not card then
		card = self:newwarcard(sid)
		self:addcard(card,reason)
	end
	logger.log("info","card",string.format("compose,pid=%s id=%s sid=%s",self.pid,card.id,sid))
	card:add("amount",1)
end

return ccardlib
