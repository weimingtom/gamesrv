--<<card 导表开始>>
local super = require "script.card"

ccard14304 = class("ccard14304",super,{
    sid = 14304,
    race = 4,
    name = "爆炸射击",
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
    magic_hurt = 5,
    recoverhp = 0,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 0,
    hp = 0,
    crystalcost = 5,
    targettype = 22,
    desc = "对1个随从造成5点伤害,并对相邻目标造成2点伤害。",
})

function ccard14304:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard14304:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard14304:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

-- warcard
require "script.war.aux"
require "script.war.warmgr"

function ccard14304:onuse(target)
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	local hurtvalue = self:gethurtvalue()
	local hurtvalue2 = self:gethurtvalue(2)
	target:addhp(-hurtvalue,self.id)
	local pos = target.pos
	local id = warobj.warcards[pos-1]
	if id then
		local lefttarget = warobj.id_card[id]
		lefttarget:addhp(-hurtvalue2,self.id)
	end
	id = warobj.warcards[pos+1]
	if id then
		local righttarget = warobj.id_card[id]
		righttarget:addhp(-hurtvalue2,self.id)
	end
end

return ccard14304
