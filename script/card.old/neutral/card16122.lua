--<<card 导表开始>>
local super = require "script.card.init"

ccard16122 = class("ccard16122",super,{
    sid = 16122,
    race = 6,
    name = "凯恩·血蹄",
    magic_immune = 0,
    assault = 0,
    sneer = 0,
    atkcnt = 1,
    shield = 0,
    warcry = 0,
    dieeffect = 1,
    secret = 0,
    sneak = 0,
    magic_hurt_adden = 0,
    type = 201,
    magic_hurt = 0,
    recoverhp = 0,
    max_amount = 1,
    composechip = 100,
    decomposechip = 10,
    atk = 4,
    hp = 5,
    crystalcost = 6,
    targettype = 0,
    desc = "亡语：召唤一个4/5的贝恩·血蹄。",
})

function ccard16122:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard16122:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard16122:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

-- warcard
require "script.war.aux"
require "script.war.warmgr"

function ccard16122:ondie()
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	local cardsid = isprettycard(self.sid) and 26626 or 16626
	local warcard = warobj:newwarcard(cardsid)
	warobj:putinwar(warcard,self.pos)
end

return ccard16122