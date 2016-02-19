--<<card 导表开始>>
local super = require "script.card.init"

ccard156002 = class("ccard156002",super,{
    sid = 156002,
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
    sneak = 0,
    magic_hurt_adden = 0,
    magic_hurt = 0,
    recoverhp = 0,
    cure_to_hurt = 0,
    recoverhp_multi = 1,
    magic_hurt_multi = 1,
    max_amount = 0,
    composechip = 0,
    decomposechip = 0,
    atk = 4,
    hp = 4,
    crystalcost = 4,
    targettype = 0,
    desc = "None",
})

function ccard156002:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard156002:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard156002:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard156002
