
__cardid = __cardid or 0
function genid()
	__cardid = __cardid + 1
	return __cardid
end

ccard = class("card",cdatabaseable)

function ccard:init(pid)
	cdatabaseable.init(self,{
		pid = pid,
		flag = "card",
	})
	self.data = {}
	self.id = genid()
end

function ccard:save()
	return self.data
end

function ccard:load(data)
	if not data or not next(data) then
		return
	end
	self.data = data
end

-- getter
function ccard:getamount()
	return self:basic_query("amount",0)
end

-- setter
function ccard:setamount(amount,reason)
	logger.log("info","card",string.format("#%d setamount,id=%d sid=%d amount=%d reason=%s",self.pid,self.id,self.sid,amount,reason))
	return self:basic_set("amount",amount)
end


function ccard.create(pid,sid,amount)
	require "script.card.cardmodule"
	amount = amount or 1
	local cardcls = assert(cardmodule[sid],"invalid card sid:" .. tostring(sid))
	local card = cardcls.new(pid)
	card:basic_set("amount",amount)
	--card:setamount(amount)
	return card
end

return ccard

