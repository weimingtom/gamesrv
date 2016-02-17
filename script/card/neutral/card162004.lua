--<<card 导表开始>>
local super = require "script.card.init"

ccard162004 = class("ccard162004",super,{
    sid = 162004,
    race = 6,
    name = "山岭巨人",
    type = 201,
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
    magic_hurt = 0,
    recoverhp = 0,
    cure_to_hurt = 0,
    cure_multi = 0,
    magic_hurt_multi = 0,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 8,
    hp = 8,
    crystalcost = 12,
    targettype = 0,
    desc = "你每有一张其他手牌,该牌的法力值消耗便减少（1）点。",
})

function ccard162004:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard162004:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard162004:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard162004
