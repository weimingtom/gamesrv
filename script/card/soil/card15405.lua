--<<card 导表开始>>
local super = require "script.card"

ccard15405 = class("ccard15405",super,{
    sid = 15405,
    race = 5,
    name = "愤怒",
    magic_immune = 0,
    assault = 0,
    sneer = 0,
    atkcnt = 0,
    shield = 0,
    warcry = 0,
    dieeffect = 0,
    secret = 0,
    sneak = 0,
    magic_hurt_adden = 0,
    type = 101,
    magic_hurt = 3,
    recoverhp = 0,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 0,
    hp = 0,
    crystalcost = 2,
    targettype = 32,
    desc = "抉择：对一个随从造成3点伤害；或者造成1点伤害并抽一张牌。",
})

function ccard15405:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard15405:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard15405:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

-- warcard
require "script.war.aux"
require "script.war.warmgr"

function ccard15405:onuse(target)
	if self.choice == 1 then
		local hurtvalue = self:gethurtvalue()
		target:addhp(-hurtvalue,self.id)
	elseif self.choice == 2 then
		local hurtvalue = self:gethurtvalue(1)
		target:addhp(-hurtvalue,self.id)
		local war = warmgr.getwar(self.warid)
		local warobj = war:getwarobj(self.pid)
		local cardsid = warobj:pickcard()
		warobj:putinhand(cardsid)
	end
end

return ccard15405
