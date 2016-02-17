--<<card 导表开始>>
local super = require "script.card.neutral.card16613"

ccard26613 = class("ccard26613",super,{
    sid = 26613,
    race = 6,
    name = "恐龙",
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
    max_amount = 0,
    composechip = 0,
    decomposechip = 0,
    atk = 5,
    hp = 5,
    crystalcost = 5,
    targettype = 0,
    desc = "None",
})

function ccard26613:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard26613:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard26613:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard26613
