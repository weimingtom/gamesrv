--<<card 导表开始>>
local super = require "script.card"

ccard16110 = class("ccard16110",super,{
    sid = 16110,
    race = 6,
    name = "纳克·伯格",
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
    type = 201,
    magic_hurt = 0,
    recoverhp = 0,
    max_amount = 1,
    composechip = 100,
    decomposechip = 10,
    atk = 0,
    hp = 4,
    crystalcost = 2,
    targettype = 0,
    desc = "在你的回合开始时,你有50%的几率额外抽一张牌。",
})

function ccard16110:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard16110:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard16110:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

-- warcard
require "script.war.aux"
require "script.war.warmgr"

function ccard16110:onbeginround(roundcnt)
	if ishit(50,100) then
		local war = warmgr.getwar(self.warid)
		local warobj = war:getwarobj(self.pid)
		local cardsid = warobj:pickcard()
		warobj:putinhand(cardsid)
	end
end

return ccard16110
