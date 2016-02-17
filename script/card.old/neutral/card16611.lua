--<<card 导表开始>>
local super = require "script.card.init"

ccard16611 = class("ccard16611",super,{
    sid = 16611,
    race = 6,
    name = "翡翠巨龙",
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
    max_amount = 0,
    composechip = 0,
    decomposechip = 0,
    atk = 7,
    hp = 6,
    crystalcost = 4,
    targettype = 0,
    desc = "None",
})

function ccard16611:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard16611:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard16611:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard16611
