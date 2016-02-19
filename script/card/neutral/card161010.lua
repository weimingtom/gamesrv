--<<card 导表开始>>
local super = require "script.card.init"

ccard161010 = class("ccard161010",super,{
    sid = 161010,
    race = 6,
    name = "纳克·伯格",
    type = 201,
    magic_immune = 0,
    assault = 0,
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
    max_amount = 1,
    composechip = 100,
    decomposechip = 10,
    atk = 0,
    hp = 4,
    crystalcost = 2,
    targettype = 0,
    desc = "在你的回合开始时,你有50%的几率额外抽一张牌。",
})

function ccard161010:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard161010:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard161010:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard161010
