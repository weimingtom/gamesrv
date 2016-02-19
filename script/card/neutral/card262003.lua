--<<card 导表开始>>
local super = require "script.card.neutral.card162003"

ccard262003 = class("ccard262003",super,{
    sid = 262003,
    race = 6,
    name = "鱼人领军",
    type = 203,
    magic_immune = 0,
    assault = 0,
    sneer = 0,
    atkcnt = 1,
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
    atk = 3,
    hp = 3,
    crystalcost = 3,
    targettype = 0,
    desc = "所有其他鱼人获得+2/+1。",
})

function ccard262003:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard262003:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard262003:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard262003
