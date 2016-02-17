--<<card 导表开始>>
local super = require "script.card.init"

ccard16621 = class("ccard16621",super,{
    sid = 16621,
    race = 6,
    name = "豺狼人",
    magic_immune = 0,
    assault = 0,
    sneer = 1,
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
    atk = 2,
    hp = 2,
    crystalcost = 2,
    targettype = 0,
    desc = "None",
})

function ccard16621:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard16621:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard16621:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard16621
