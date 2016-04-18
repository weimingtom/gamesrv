require "script.card.carddb"

ccardlib = class("ccardlib")

function ccardlib:init(pid)
	self.pid = pid
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
	return data
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

function ccardlib:newcard(conf)
	require "script.card.init"
	local sid = assert(conf.sid)
	local id = self:gencardid()
	local card = ccard.create({
		sid = sid,
		pid = self.pid,
	})
	card.id = id
	for k,v in pairs(conf) do
		if k ~= "sid" then
			card:set(k,v)
		end
	end
	return card
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

--/*
--得到卡牌数量
--/*
function ccardlib:getcardnum(sid)
	local card = self:getcardbysid(sid)
	return card and card:get("amount",0) or 0
end

function ccardlib:addcardbysid(sid,num,reason)
	local card = self:getcardbysid(sid)
	if not card then
		card = self:newcard({
			sid = sid,
		})
		self:addcard(card)
	end
	local oldamount = card:get("amount",0)
	logger.log("info","card",string.format("[addcardbysid] pid=%s id=%s sid=%s amount=%d+%d",self.pid,card.id,sid,oldamount,num))
	card:add("amount",num)
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
	logger.log("info","card",string.format("[decompose] pid=%s id=%s sid=%s amount=%d-%d",self.pid,id,card.sid,oldamount,amount))
	if newamount > 0 then
		card:set("amount",newamount)
	else
		self:delcard(id,reason)
	end
	local cardcls = getclassbycardsid(card.sid)
	local decomposechip = cardcls.decomposechip * amount
	player:addchip(decomposechip,reason)
end

function ccardlib:compose(sid)
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
		card = self:newcard({
			sid = sid,
		})
		self:addcard(card,reason)
	end
	logger.log("info","card",string.format("[compose] pid=%s id=%s sid=%s",self.pid,card.id,sid))
	card:add("amount",1)
end

return ccardlib
