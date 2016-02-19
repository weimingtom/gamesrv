--<<card 导表开始>>
local super = require "script.card.init"

ccard133002 = class("ccard133002",super,{
    sid = 133002,
    race = 3,
    name = "暗影狂乱",
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
    crystalcost = 4,
    targettype = 22,
    desc = "直到回合结束,获得一个攻击力小于或等于3的敌方随从的控制权。",
})

function ccard133002:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard133002:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard133002:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard133002
