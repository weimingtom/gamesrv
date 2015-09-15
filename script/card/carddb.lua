
require "script.card.init"
require "script.war.aux"

ccarddb = class("ccarddb",cdatabaseable)

function ccarddb:init(conf)
	cdatabaseable.init(self,conf)
	self.data = {}
	self.id_card = {}
	self.sid_cards = {}
end

function ccarddb:save()
	local data = {}
	data.data = self.data
	local d1 = {}
	for sid,cards in pairs(self.sid_cards) do
		local d2 = {}
		for _,card in ipairs(cards) do
			table.insert(d2,card:save())
		end
		d1[tostring(sid)] = d2
	end
	data.sid_cards = d1
	return data
end

function ccarddb:load(data)
	if not data or not next(data) then
		return
	end
	self.data = data.data
	for sid,cards_data in pairs(data.sid_cards) do
		sid = tonumber(sid)
		for _,v in ipairs(cards_data) do
			local card = ccard.create(self.pid,sid)
			card:load(v)
			self:__addcard(card)
		end
	end
end

function ccarddb:clear()
	logger.log("info","card",string.format("#%d clear card(flag=%s)",self.pid,self.__flag))
	self.data = {}
	self.id_card = {}
	self.sid_cards = {}
end

function ccarddb:getcard(cardid)
	return self.id_card[cardid]
end

function ccarddb:__addcard(card)
	assert(getracename(card.race) == self.__flag)
	self:check_sid_cards(card.sid)
	local cardid = card.cardid
	assert(self.id_card[cardid] == nil,"repeat cardid:" .. tostring(cardid))
	self.id_card[cardid] = card
	local pos = 1
	for i,v in ipairs(self.sid_cards[card.sid]) do
		if card:getamount() >= v:getamount() then
			pos = i
			break	
		end
	end
	table.insert(self.sid_cards[card.sid],pos,card)
end

-- wrapper
function ccarddb:addcard(card,reason)
	logger.log("info","card",string.format("%d addcard,cardid=%d sid=%d amount=%d reason=%s",self.pid,card.cardid,card.sid,card:getamount(),reason))
	self:__addcard(card)
	self:afteraddcard(card)
end

function ccarddb:delcard(card,reason)
	assert(getracename(card.race) == self.__flag)
	local cardid = card.cardid
	assert(self.id_card[cardid],"not exists cardid:" .. tostring(cardid))
	logger.log("info","card",string.format("%d delcard,cardid=%d sid=%d amount=%d reason=%s",self.pid,cardid,card.sid,card:getamount(),reason))
	self.id_card[cardid] = nil
	local cards = self.sid_cards[card.sid]
	for k,v in ipairs(cards) do
		if v.cardid == cardid then
			table.remove(cards,k)
			break
		end
	end
	self:afterdelcard(card)
end

function ccarddb:afteraddcard(card)
end

function ccarddb:afterdelcard(card)
end

function ccarddb:check_sid_cards(sid)
	assert(getclassbycardsid(sid) ~= nil,"Invliad card sid:" .. tostring(sid))
	if not self.sid_cards[sid] then
		self.sid_cards[sid] = {}
	end
end

function ccarddb:addcardbysid(sid,amount,reason)
	self:check_sid_cards(sid)
	-- merge
	local cardcls = getclassbycardsid(sid)	
	local max_amount = cardcls.max_amount
	assert(max_amount ~= 0,"max_amount == 0")
	for _,card in ipairs(self.sid_cards[sid]) do
		local num  = card:getamount()
		if num < max_amount then
			local addamount = math.min(amount,max_amount-num)
			amount = amount - addamount
			card:setamount(num+addamount)
			if amount <= 0 then
				break
			end
		end
	end
	local cnt = math.floor(amount / max_amount)
	local leftamount = amount - max_amount * cnt
	local card
	for i=1,cnt do
		card = ccard.create(self.pid,sid,max_amount)
		self:addcard(card,reason)
	end
	if leftamount > 0 then
		card = ccard.create(self.pid,sid,leftamount)
		self:addcard(card,reason)
	end
end

function ccarddb:getamountbysid(sid)
	self:check_sid_cards(sid)
	local amount = 0
	for _,card in ipairs(self.sid_cards[sid]) do
		amount = amount + card:getamount()
	end
	return amount
end

function ccarddb:delcardbysid(sid,amount,reason)
	self:check_sid_cards(sid)
	local cards = self.sid_cards[sid]
	local delcards = {}
	for _,card in ipairs(cards) do
		if amount == 0 then
			break
		end
		if amount >= card:getamount() then
			amount = amount - card:getamount()
			table.insert(delcards,card)
		else
			amount = 0
			card:setamount(card:getamount()-amount,reason)
			break
		end
	end
	assert(amount == 0,"[delcardbysid] hasn't enough amount:" .. tostring(amount))
	for _,card in ipairs(delcards) do
		self:delcard(card,reason)
	end
end

function ccarddb:compose(sid)
	local player = playermgr.getplayer(self.pid)	
	local cardcls = getclassbycardsid(sid)
	local composechip = cardcls.composechip
	if not player:validpay("chip",composechip) then
		return
	end
	player:addchip(-composechip,"compose")
	self:addcardbysid(sid,1,"compose")
end

function ccarddb:decompose(card,amount)
	amount = amount or 1
	local oldamount = card:getamount()
	if amount > oldamount then
		error(string.format("[decompose] amount not enough: %d > %d",amount,oldamount))
	end
	local newamount = oldamount - amount
	local player = playermgr.getplayer(self.pid)
	local cardcls = getclassbycardsid(card.sid)
	local decomposechip = cardcls.decomposechip * amount
	local reason = "decompose"
	if newamount > 0 then
		card:setamount(newamount,reason)
	else
		self:delcard(card,reason)
	end
	player:addchip(decomposechip,reason)
end

function ccarddb:decomposeleft()
	local leftcards = self:getleftcards()
	for _,card in ipairs(leftcards) do
		self:decompose(card,card:getamount())
	end
end

function ccarddb:getleftcards()
	local leftcards = {}
	for sid,cards in pairs(self.sid_cards) do
		local amount = self:getamountbysid(sid)
		local cardcls = getclassbycardsid(sid)
		local limit = cardcls.max_amount
		if amount > limit then
			local found = false
			for _,card in ipairs(cards) do
				if found then
					table.insert(leftcards,card)
				else
					if card:getamount() == limit then
						found = true
					else
						table.insert(leftcards,card)
					end
				end
			end
			assert(found == true)
		end
	end
	return leftcards
end

function ccarddb:usecard(cardid)
	
end

return ccarddb
