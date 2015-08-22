--<<card 导表开始>>
local super = require "script.card"

ccard16107 = class("ccard16107",super,{
    sid = 16107,
    race = 6,
    name = "炎魔之王拉格纳罗斯",
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
    type = 201,
    magic_hurt = 0,
    recoverhp = 0,
    max_amount = 1,
    composechip = 100,
    decomposechip = 10,
    atk = 8,
    hp = 8,
    crystalcost = 8,
    targettype = 0,
    desc = "无法攻击,在你的回合结束时,对一个随机敌人造成8点伤害。",
})

function ccard16107:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard16107:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard16107:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end


-- warcard
require "script.war.aux"
require "script.war.warmgr"

function ccard16107:onendround(roundnct)
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	local hitids = copy(warobj.enemy.warcards)
	table.insert(hitids,warobj.enemy.hero.id)
	local id = randlist(hitids)
	local hurtvalue = 8
	if id == warobj.enemy.hero.id then
		warobj.enemy.hero:addhp(-hurtvalue,self.id)
	else
		local warcard = warobj.enemy.id_card[id]
		warcard:addhp(-hurtvalue,self.id)
	end
end

return ccard16107
