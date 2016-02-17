--<<card 导表开始>>
local super = require "script.card.init"

ccard165037 = class("ccard165037",super,{
    sid = 165037,
    race = 6,
    name = "暗鳞治愈者",
    type = 201,
    magic_immune = 0,
    assault = 0,
    sneer = 0,
    atkcnt = 1,
    shield = 0,
    warcry = 1,
    dieeffect = 0,
    secret = 0,
    sneak = 0,
    magic_hurt_adden = 0,
    magic_hurt = 0,
    recoverhp = 2,
    cure_to_hurt = 0,
    cure_multi = 0,
    magic_hurt_multi = 0,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 4,
    hp = 5,
    crystalcost = 5,
    targettype = 0,
    desc = "战吼：为所有友方角色恢复2点生命值。",
})

function ccard165037:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard165037:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard165037:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard165037
