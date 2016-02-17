--<<card 导表开始>>
local super = require "script.card.init"

ccard16423 = class("ccard16423",super,{
    sid = 16423,
    race = 6,
    name = "战利品贮藏者",
    magic_immune = 0,
    assault = 0,
    sneer = 0,
    atkcnt = 1,
    shield = 0,
    warcry = 1,
    dieeffect = 1,
    secret = 0,
    sneak = 0,
    magic_hurt_adden = 0,
    type = 205,
    magic_hurt = 0,
    recoverhp = 0,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 2,
    hp = 1,
    crystalcost = 2,
    targettype = 0,
    desc = "亡语：抽1张牌。",
})

function ccard16423:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard16423:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard16423:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

-- warcard
require "script.war.aux"
require "script.war.warmgr"

function ccard16423:ondie()
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	local cardsid = warobj:pickcard()
	warobj:putinhand(cardsid)
end

return ccard16423
