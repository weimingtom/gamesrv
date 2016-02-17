--<<card 导表开始>>
local super = require "script.card.soil.card156002"

ccard256002 = class("ccard256002",super,{
    sid = 256002,
    race = 5,
    name = "利爪德鲁伊（冲锋）",
    type = 201,
    magic_immune = 0,
    assault = 1,
    sneer = 0,
    atkcnt = 1,
    shield = 0,
    warcry = 0,
    dieeffect = 0,
    secret = 0,
    sneak = 0,
    magic_hurt_adden = 0,
    magic_hurt = 0,
    recoverhp = 0,
    cure_to_hurt = 0,
    cure_multi = 0,
    magic_hurt_multi = 0,
    max_amount = 0,
    composechip = 0,
    decomposechip = 0,
    atk = 4,
    hp = 4,
    crystalcost = 4,
    targettype = 0,
    desc = "None",
})

function ccard256002:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard256002:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard256002:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard256002
