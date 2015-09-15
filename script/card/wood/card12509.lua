--<<card 导表开始>>
local super = require "script.card.init"

ccard12509 = class("ccard12509",super,{
    sid = 12509,
    race = 2,
    name = "奉献",
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
    magic_hurt = 2,
    recoverhp = 0,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 0,
    hp = 0,
    crystalcost = 4,
    targettype = 0,
    desc = "对所有敌人造成2点伤害。",
})

function ccard12509:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard12509:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard12509:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

-- warcard
require "script.war.aux"
require "script.war.warmgr"

function ccard12509:onuse(target)
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	local enemy = warobj.enemy
	local hurtvalue = self:gethurtvalue()
	for _,id in ipairs(enemy.warcards) do
		local warcard = enemy.id_card[id]
		warcard:addhp(-hurtvalue,self.id)
	end
	enemy.hero:addhp(-hurtvalue,self.id)
end

return ccard12509
