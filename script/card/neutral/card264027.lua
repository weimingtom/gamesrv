--<<card 导表开始>>
local super = require "script.card.neutral.card164027"

ccard264027 = class("ccard264027",super,{
    sid = 264027,
    race = 6,
    name = "麦田傀儡",
    type = 206,
    magic_immune = 0,
    assault = 0,
    sneer = 0,
    atkcnt = 1,
    shield = 0,
    warcry = 0,
    dieeffect = 1,
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
    atk = 2,
    hp = 3,
    crystalcost = 3,
    targettype = 0,
    desc = "亡语：召唤一个2/1的损坏的傀儡。",
})

function ccard264027:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard264027:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard264027:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard264027
