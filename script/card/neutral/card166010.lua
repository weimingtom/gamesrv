--<<card 导表开始>>
local super = require "script.card.init"

ccard166010 = class("ccard166010",super,{
    sid = 166010,
    race = 6,
    name = "欢乐姐妹",
    type = 201,
    magic_immune = 1,
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
    max_amount = 0,
    composechip = 0,
    decomposechip = 0,
    atk = 3,
    hp = 5,
    crystalcost = 3,
    targettype = 0,
    desc = "无法成为法术或英雄技能的目标。",
})

function ccard166010:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard166010:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard166010:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard166010
