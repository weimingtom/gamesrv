--<<card 导表开始>>
local super = require "script.card.init"

ccard16408 = class("ccard16408",super,{
    sid = 16408,
    race = 6,
    name = "牛头人战士",
    magic_immune = 0,
    assault = 0,
    sneer = 1,
    atkcnt = 1,
    shield = 0,
    warcry = 0,
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
    crystalcost = 3,
    targettype = 0,
    desc = "嘲讽,激怒：+3攻击力。",
})

function ccard16408:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard16408:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard16408:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

-- warcard
require "script.war.aux"
require "script.war.warmgr"

function ccard16408:onenrage()
	self:addbuff({addatk=3,},self.id,self.sid)
end

function ccard16408:onunenrage()
	self:delbuff(self.id)
end

return ccard16408
