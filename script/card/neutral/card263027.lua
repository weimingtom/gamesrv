--<<card 导表开始>>
local super = require "script.card.neutral.card163027"

ccard263027 = class("ccard263027",super,{
    sid = 263027,
    race = 6,
    name = "血帆海盗",
    type = 204,
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
    magic_hurt = 0,
    recoverhp = 0,
    cure_to_hurt = 0,
    cure_multi = 0,
    magic_hurt_multi = 0,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 1,
    hp = 2,
    crystalcost = 1,
    targettype = 0,
    desc = "战吼：使对手的武器失去1点耐久度。",
})

function ccard263027:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard263027:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard263027:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard263027
