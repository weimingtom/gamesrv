--<<card 导表开始>>
local super = require "script.card.neutral.card16541"

ccard26541 = class("ccard26541",super,{
    sid = 26541,
    race = 6,
    name = "藏宝海湾保镖",
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
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 5,
    hp = 4,
    crystalcost = 5,
    targettype = 0,
    desc = "嘲讽",
})

function ccard26541:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard26541:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard26541:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard26541
