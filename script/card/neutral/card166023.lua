--<<card 导表开始>>
local super = require "script.card.init"

ccard166023 = class("ccard166023",super,{
    sid = 166023,
    race = 6,
    name = "侏儒变鸡器",
    type = 206,
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
    max_amount = 0,
    composechip = 0,
    decomposechip = 0,
    atk = 0,
    hp = 3,
    crystalcost = 1,
    targettype = 0,
    desc = "在你回合的开始阶段,将随机一名随从变成一只1/1的小鸡。",
})

function ccard166023:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard166023:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard166023:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard166023
