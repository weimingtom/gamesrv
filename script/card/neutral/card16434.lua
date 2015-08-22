--<<card 导表开始>>
local super = require "script.card"

ccard16434 = class("ccard16434",super,{
    sid = 16434,
    race = 6,
    name = "黑铁矮人",
    magic_immune = 0,
    assault = 0,
    sneer = 0,
    atkcnt = 1,
    shield = 0,
    warcry = 1,
    dieeffect = 0,
    secret = 0,
    sneak = 1,
    magic_hurt_adden = 0,
    type = 201,
    magic_hurt = 0,
    recoverhp = 0,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 4,
    hp = 4,
    crystalcost = 4,
    targettype = 32,
    desc = "战吼：在本回合中,使一个随从获得 +2 攻击力。",
})

function ccard16434:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard16434:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard16434:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

-- warcard
require "script.war.aux"
require "script.war.warmgr"

function ccard16434:onuse(target)
	target:addbuff({addatk=2,lifecircle=1},self.id,self.sid)
end

return ccard16434
