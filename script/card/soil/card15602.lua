--<<card 导表开始>>
local super = require "script.card"

ccard15602 = class("ccard15602",super,{
    sid = 15602,
    race = 5,
    name = "利爪德鲁伊（冲锋）",
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
    type = 201,
    magic_hurt = 0,
    recoverhp = 0,
    max_amount = 0,
    composechip = 0,
    decomposechip = 0,
    atk = 4,
    hp = 4,
    crystalcost = 4,
    targettype = 0,
    desc = "None",
})

function ccard15602:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard15602:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard15602:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard15602
