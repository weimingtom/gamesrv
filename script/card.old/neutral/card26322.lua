--<<card 导表开始>>
local super = require "script.card.neutral.card16322"

ccard26322 = class("ccard26322",super,{
    sid = 26322,
    race = 6,
    name = "加基森拍卖师",
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
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 4,
    hp = 4,
    crystalcost = 5,
    targettype = 0,
    desc = "每当你施放一个法术时,抽一张牌。",
})

function ccard26322:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard26322:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard26322:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard26322
