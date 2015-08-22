--<<card 导表开始>>
local super = require "script.card"

ccard12101 = class("ccard12101",super,{
    sid = 12101,
    race = 2,
    name = "提里奥·弗丁",
    magic_immune = 0,
    assault = 0,
    sneer = 1,
    atkcnt = 1,
    shield = 1,
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
    atk = 6,
    hp = 6,
    crystalcost = 8,
    targettype = 23,
    desc = "圣盾,嘲讽,亡语：装备一把5/3的灰烬使者。",
})

function ccard12101:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard12101:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard12101:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end


-- warcard
require "script.war.aux"
require "script.war.warmgr"

function ccard12101:ondie()
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	local cardsid = isprettycard(self.sid) and 22603 or 12603
	local warcard = warobj:newwarcard(cardsid)
	warobj:addcard(warcard)
	warcard:onuse()
end

return ccard12101
