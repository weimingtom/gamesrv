--<<card 导表开始>>
local super = require "script.card.init"

ccard161019 = class("ccard161019",super,{
    sid = 161019,
    race = 6,
    name = "格尔宾·梅尔托克",
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
    recoverhp = 0,
    cure_to_hurt = 0,
    cure_multi = 0,
    magic_hurt_multi = 0,
    max_amount = 1,
    composechip = 100,
    decomposechip = 10,
    atk = 6,
    hp = 6,
    crystalcost = 6,
    targettype = 0,
    desc = "战吼：进行一次惊人的发明。",
})

function ccard161019:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard161019:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard161019:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard161019
