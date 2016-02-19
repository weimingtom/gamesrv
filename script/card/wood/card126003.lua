--<<card 导表开始>>
local super = require "script.card.init"

ccard126003 = class("ccard126003",super,{
    sid = 126003,
    race = 2,
    name = "灰烬使者",
    type = 301,
    magic_immune = 0,
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
    atk = 5,
    hp = 3,
    crystalcost = 5,
    targettype = 0,
    desc = "None",
})

function ccard126003:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard126003:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard126003:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard126003
