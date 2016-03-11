--/*
--卡牌基类，必须继承后才能实例化
--*/
ccard = class("card",cdatabaseable)

function ccard:init(conf)
	cdatabaseable.init(self,{
		pid = assert(conf.pid),
		flag = "card",
	})
	self.data = {}
	self.id = assert(conf.id)
	self.sid = assert(conf.sid)
end

function ccard:save()
	local data = {}
	data.data = self.data
	data.id = self.id
	data.sid = self.sid
	return data
end

function ccard:load(data)
	if not data or not next(data) then
		return
	end
	self.data = data.data
	self.id = data.id
	self.sid = data.sid
end

--/*
--新建卡牌
--@param table conf
--@example:
--local card = ccard.create({
--		pid = 10001,
--		sid = 121001,
--		id = 1,
--		amount = 1,
--})
--*/
function ccard.create(conf)
	require "script.card.cardmodule"
	local sid = assert(conf.sid)
	local id = assert(conf.id)
	local pid = assert(conf.pid)
	local cardcls = assert(cardmodule[sid],"invalid card sid:" .. tostring(sid))
	local card = cardcls.new(conf)
	return card
end

return ccard

