--<<card 导表开始>>
local super = require "script.card.neutral.card166008"

ccard266008 = class("ccard266008",super,{
    sid = 266008,
    race = 6,
    name = "伊瑟拉的觉醒",
    type = 101,
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
    magic_hurt = 5,
    recoverhp = 0,
    cure_to_hurt = 0,
    cure_multi = 0,
    magic_hurt_multi = 0,
    max_amount = 0,
    composechip = 0,
    decomposechip = 0,
    atk = 0,
    hp = 0,
    crystalcost = 2,
    targettype = 0,
    desc = "对除了伊瑟拉以外的全部角色造成5点伤害",
})

function ccard266008:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard266008:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard266008:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard266008
