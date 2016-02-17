--<<card 导表开始>>
local super = require "script.card.init"

ccard16405 = class("ccard16405",super,{
    sid = 16405,
    race = 6,
    name = "风怒鹰身人",
    magic_immune = 0,
    assault = 0,
    sneer = 0,
    atkcnt = 2,
    shield = 0,
    warcry = 0,
    dieeffect = 0,
    secret = 0,
    sneak = 0,
    magic_hurt_adden = 0,
    type = 201,
    magic_hurt = 0,
    recoverhp = 0,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 4,
    hp = 5,
    crystalcost = 6,
    targettype = 0,
    desc = "风怒",
})

function ccard16405:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard16405:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard16405:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard16405
