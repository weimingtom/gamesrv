--<<card 导表开始>>
local super = require "script.card.wood.card124005"

ccard224005 = class("ccard224005",super,{
    sid = 224005,
    race = 2,
    name = "智慧祝福",
    type = 101,
    magic_immune = 0,
    assault = 0,
    sneer = 0,
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
    atk = 0,
    hp = 0,
    crystalcost = 1,
    targettype = 32,
    desc = "选择一个随从,每当它进行攻击时,抽一张牌。",
})

function ccard224005:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard224005:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard224005:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard224005
