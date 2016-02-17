--<<card 导表开始>>
local super = require "script.card.init"

ccard16308 = class("ccard16308",super,{
    sid = 16308,
    race = 6,
    name = "日怒保卫者",
    magic_immune = 0,
    assault = 0,
    sneer = 0,
    atkcnt = 1,
    shield = 0,
    warcry = 1,
    dieeffect = 0,
    secret = 0,
    sneak = 0,
    magic_hurt_adden = 0,
    type = 201,
    magic_hurt = 0,
    recoverhp = 0,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 2,
    hp = 3,
    crystalcost = 2,
    targettype = 0,
    desc = "战吼：使邻近的随从获得嘲讽。",
})

function ccard16308:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard16308:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard16308:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

-- warcard
require "script.war.aux"
require "script.war.warmgr"

function ccard16308:onuse(target)
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	local pos = self.pos
	local id = warobj.warcards[pos-1] 
	if id then
		local leftfootman = warobj.id_card[id]
		leftfootman:setstate("sneer",1)
	end
	id = warobj.warcards[pos+1]
	if id then
		local rightfootman = warobj.id_card[id]
		rightfootman:setstate("sneer",1)
	end
end

return ccard16308
