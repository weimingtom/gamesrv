--<<card 导表开始>>
local super = require "script.card.init"

ccard11401 = class("ccard11401",super,{
    sid = 11401,
    race = 1,
    name = "冰锥术",
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
    magic_hurt = 1,
    recoverhp = 0,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 0,
    hp = 0,
    crystalcost = 4,
    targettype = 22,
    desc = "冻结一个随从和其相邻随从,并对他们造成1点伤害",
})

function ccard11401:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard11401:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard11401:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

-- warcard
require "script.war.warmgr"
function ccard11401:onuse(target)
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	local owner = war:getowner(target.id)
	local id1 = owner.warcards[target.pos-1]
	local id2 = owner.warcards[target.pos+1]
	local hurtvalue = self:gethurtvalue()
	target:addhp(-hurtvalue,self.id)
	target:setstate("freeze",1)
	if id1 then
		local lefttarget = owner.id_card[id1]
		lefttarget:addhp(-hurtvalue,self.id)
		lefttarget:setstate("freeze",1)
	end
	if id2 then
		local righttarget = owner.id_card[id2]
		righttarget:addhp(-hurtvalue,self.id)
		righttarget:setstate("freeze",1)
	end
end

return ccard11401
