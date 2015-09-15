--<<card 导表开始>>
local super = require "script.card.init"

ccard16618 = class("ccard16618",super,{
    sid = 16618,
    race = 6,
    name = "部落的力量",
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
    max_amount = 0,
    composechip = 0,
    decomposechip = 0,
    atk = 0,
    hp = 0,
    crystalcost = 4,
    targettype = 0,
    desc = "随即召唤一个部落勇士",
})

function ccard16618:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard16618:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard16618:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

-- warcard
require "script.war.aux"
require "script.war.warmgr"

function ccard16618:onuse(target)
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	local hitsids = {}
	if isprettycard(self.sid) then
		hitsids = {26122,26408,}
	else
		hitsids = {16122,16408,}
	end
	local cardsid = randlist(hitsids)
	local warcard = warobj:newwarcard(cardsid)
	warobj:putinwar(warcard)
end

return ccard16618
