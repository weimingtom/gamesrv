--<<card 导表开始>>
local super = require "script.card"

ccard16529 = class("ccard16529",super,{
    sid = 16529,
    race = 6,
    name = "古拉巴什狂暴者",
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
    type = 201,
    magic_hurt = 0,
    recoverhp = 0,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 2,
    hp = 7,
    crystalcost = 5,
    targettype = 0,
    desc = "每当该随从受到伤害时,获得+3攻击力。",
})

function ccard16529:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard16529:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard16529:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

-- warcard
require "script.war.aux"
require "script.war.warmgr"

function ccard16529:onhurt(hurtvalue,srcid)
	self:addbuff({addatk=3,},self.id,self.sid)
end

return ccard16529
