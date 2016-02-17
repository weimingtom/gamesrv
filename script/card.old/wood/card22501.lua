--<<card 导表开始>>
local ccustomcard = require "script.card.wood.card12501"

ccard22501 = class("ccard22501",ccustomcard,{
    sid = 22501,
    race = 2,
    name = "圣光的正义",
    magic_immune = 0,
    assault = 0,
    sneer = 0,
    atkcnt = 2,
    shield = 0,
    warcry = 0,
    dieeffect = 0,
    secret = 0,
    sneak = 0,
    magic_hurt_adden = 0,
    type = 301,
    magic_hurt = 0,
    recoverhp = 0,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 1,
    hp = 1,
    crystalcost = 1,
    targettype = 0,
    desc = "None",
})

function ccard22501:init(pid)
    ccard.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard22501:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard22501:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard22501
