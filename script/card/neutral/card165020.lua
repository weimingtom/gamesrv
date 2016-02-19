--<<card 导表开始>>
local super = require "script.card.init"

ccard165020 = class("ccard165020",super,{
    sid = 165020,
    race = 6,
    name = "银背族长",
    type = 202,
    magic_immune = 0,
    assault = 0,
    sneer = 1,
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
    atk = 1,
    hp = 4,
    crystalcost = 3,
    targettype = 0,
    desc = "嘲讽",
})

function ccard165020:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard165020:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard165020:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard165020
