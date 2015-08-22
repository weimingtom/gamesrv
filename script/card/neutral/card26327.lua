--<<card 导表开始>>
local super = require "script.card.neutral.card16327"

ccard26327 = class("ccard26327",super,{
    sid = 26327,
    race = 6,
    name = "血帆海盗",
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
    type = 204,
    magic_hurt = 0,
    recoverhp = 0,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 1,
    hp = 2,
    crystalcost = 1,
    targettype = 0,
    desc = "战吼：使对手的武器失去1点耐久度。",
})

function ccard26327:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard26327:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard26327:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard26327
