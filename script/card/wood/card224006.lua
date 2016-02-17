--<<card 导表开始>>
local super = require "script.card.wood.card124006"

ccard224006 = class("ccard224006",super,{
    sid = 224006,
    race = 2,
    name = "银色保卫者",
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
    atk = 2,
    hp = 2,
    crystalcost = 1,
    targettype = 12,
    desc = "战吼：使一个友方随从获得圣盾。",
})

function ccard224006:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard224006:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard224006:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard224006
