--<<card 导表开始>>
local super = require "script.card.fire.card14201"

ccard24201 = class("ccard24201",super,{
    sid = 24201,
    race = 4,
    name = "毒蛇陷阱",
    magic_immune = 0,
    assault = 0,
    sneer = 0,
    atkcnt = 0,
    shield = 0,
    warcry = 0,
    dieeffect = 0,
    secret = 1,
    sneak = 0,
    magic_hurt_adden = 0,
    type = 101,
    magic_hurt = 0,
    recoverhp = 0,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 0,
    hp = 0,
    crystalcost = 2,
    targettype = 0,
    desc = "奥秘：当你的1个随从遭到攻击时,召唤3条1/1毒蛇。",
})

function ccard24201:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard24201:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard24201:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard24201
