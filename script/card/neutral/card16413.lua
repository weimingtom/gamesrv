--<<card 导表开始>>
local super = require "script.card.init"

ccard16413 = class("ccard16413",super,{
    sid = 16413,
    race = 6,
    name = "白银之手骑士",
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
    type = 201,
    magic_hurt = 0,
    recoverhp = 0,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 4,
    hp = 4,
    crystalcost = 5,
    targettype = 0,
    desc = "战吼：召唤一个2/2的侍从。",
})

function ccard16413:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard16413:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard16413:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

-- warcard
require "script.war.aux"
require "script.war.warmgr"

function ccard16413:onuse(target)
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	if #warobj.warcards < WAR_CARD_LIMIT then
		local cardsid = isprettycard(self.sid) and 26601 or 16601
		local warcard = warobj:newwarcard(cardsid)
		warobj:putinwar(warcard,self.pos+1)
	end
end

return ccard16413
