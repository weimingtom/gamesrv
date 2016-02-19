--<<card 导表开始>>
local super = require "script.card.fire.card142001"

ccard242001 = class("ccard242001",super,{
    sid = 242001,
    race = 4,
    name = "毒蛇陷阱",
    type = 102,
    magic_immune = 0,
    assault = 0,
    sneer = 0,
    atkcnt = 0,
    shield = 0,
    warcry = 0,
    dieeffect = 0,
    sneak = 0,
    magic_hurt_adden = 0,
    magic_hurt = 0,
    recoverhp = 0,
    cure_to_hurt = 0,
    recoverhp_multi = 1,
    magic_hurt_multi = 1,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 0,
    hp = 0,
    crystalcost = 2,
    targettype = 0,
    desc = "奥秘：当你的1个随从遭到攻击时,召唤3条1/1毒蛇。",
})

function ccard242001:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard242001:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard242001:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard242001
