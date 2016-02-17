--<<card 导表开始>>
local super = require "script.card.wood.card124001"

ccard224001 = class("ccard224001",super,{
    sid = 224001,
    race = 2,
    name = "忏悔",
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
    desc = "奥秘：当你的对手召唤一个随从,使该随从的生命值降为1。",
})

function ccard224001:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard224001:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard224001:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard224001
