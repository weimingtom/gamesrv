--<<card 导表开始>>
local super = require "script.card.init"

ccard16330 = class("ccard16330",super,{
    sid = 16330,
    race = 6,
    name = "愤怒的小鸡",
    magic_immune = 0,
    assault = 0,
    sneer = 0,
    atkcnt = 1,
    shield = 0,
    warcry = 0,
    dieeffect = 0,
    secret = 0,
    sneak = 0,
    magic_hurt_adden = 0,
    type = 202,
    magic_hurt = 0,
    recoverhp = 0,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 1,
    hp = 1,
    crystalcost = 1,
    targettype = 0,
    desc = "激怒：+5攻击力。",
})

function ccard16330:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard16330:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard16330:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

-- warcard
require "script.war.aux"
require "script.war.warmgr"

function ccard16330:onenrage()
	self:addbuff({addatk=5,},self.id,self.sid)
end

function ccard16330:onunenrage()
	self:delbuff(self.id)
end

return ccard16330
