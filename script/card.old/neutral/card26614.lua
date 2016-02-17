--<<card 导表开始>>
local super = require "script.card.neutral.card16614"

ccard26614 = class("ccard26614",super,{
    sid = 26614,
    race = 6,
    name = "松鼠",
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
    type = 202,
    magic_hurt = 0,
    recoverhp = 0,
    max_amount = 0,
    composechip = 0,
    decomposechip = 0,
    atk = 1,
    hp = 1,
    crystalcost = 1,
    targettype = 0,
    desc = "None",
})

function ccard26614:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard26614:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard26614:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard26614
