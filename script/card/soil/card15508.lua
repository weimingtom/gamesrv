--<<card 导表开始>>
local super = require "script.card"

ccard15508 = class("ccard15508",super,{
    sid = 15508,
    race = 5,
    name = "横扫",
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
    magic_hurt = 4,
    recoverhp = 0,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 0,
    hp = 0,
    crystalcost = 4,
    targettype = 23,
    desc = "对一个敌人造成4点伤害,并对所有其他敌人造成1点伤害。",
})

function ccard15508:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard15508:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard15508:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

-- warcard
require "script.war.aux"
require "script.war.warmgr"

function ccard15508:onuse(target)
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	local hurtvalue1 = self:gethurtvalue()
	local hurtvalue2 = self:gethurtvalue(1)
	target:addhp(-hurtvalue1,self.id)
	local warcard
	for i,id in ipairs(warobj.enemy.warcards) do
		if id ~= target.id then
			warcard = warobj.enemy.id_card[id]
			warcard:addhp(-hurtvalue2,self.id)
		end
	end
end
return ccard15508
