--<<card 导表开始>>
local super = require "script.card.wood.card124003"

ccard224003 = class("ccard224003",super,{
    sid = 224003,
    race = 2,
    name = "崇高牺牲",
    type = 101,
    magic_immune = 0,
    assault = 0,
    sneer = 0,
    atkcnt = 0,
    shield = 0,
    warcry = 0,
    dieeffect = 0,
    secret = 1,
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
    crystalcost = 1,
    targettype = 0,
    desc = "奥秘：每当一个敌人攻击时,召唤一个2/1的防御者,并使其成为攻击的目标。",
})

function ccard224003:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard224003:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard224003:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard224003
