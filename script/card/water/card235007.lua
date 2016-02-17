--<<card 导表开始>>
local super = require "script.card.water.card135007"

ccard235007 = class("ccard235007",super,{
    sid = 235007,
    race = 3,
    name = "神圣之灵",
    type = 101,
    magic_immune = 0,
    assault = 0,
    sneer = 0,
    atkcnt = 0,
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
    atk = 0,
    hp = 0,
    crystalcost = 2,
    targettype = 32,
    desc = "使一个随从的生命值翻倍。",
})

function ccard235007:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard235007:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard235007:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard235007
