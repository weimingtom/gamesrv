--<<card 导表开始>>
local super = require "script.card.golden.card11303"

ccard21303 = class("ccard21303",super,{
    sid = 21303,
    race = 1,
    name = "法术反制",
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
    type = 101,
    magic_hurt = 0,
    recoverhp = 0,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 0,
    hp = 0,
    crystalcost = 3,
    targettype = 0,
    desc = "奥秘：当你的对手施放法术时,法制该法术",
})

function ccard21303:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard21303:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard21303:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard21303
