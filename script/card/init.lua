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
	self.sid = assert(conf.sid)
	self.id = nil --  加入容器后初始化
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
--		amount = 1,
--})
--*/
function ccard.create(conf)
	require "script.card.cardmodule"
	local sid = assert(conf.sid)
	local pid = assert(conf.pid)
	local cardcls = assert(cardmodule[sid],"invalid card sid:" .. tostring(sid))
	local card = cardcls.new(conf)
	return card
end

return ccard

