--<<card 导表开始>>
local super = require "script.card.wood.card12301"

ccard22301 = class("ccard22301",super,{
    sid = 22301,
    race = 2,
    name = "神圣愤怒",
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
    type = 101,
    magic_hurt = 0,
    recoverhp = 0,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 0,
    hp = 0,
    crystalcost = 5,
    targettype = 23,
    desc = "抽一张牌,并造成等同于其法力值消耗的伤害。",
})

function ccard22301:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard22301:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard22301:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard22301
