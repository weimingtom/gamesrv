--<<card 导表开始>>
local super = require "script.card.init"

ccard12405 = class("ccard12405",super,{
    sid = 12405,
    race = 2,
    name = "智慧祝福",
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
    crystalcost = 1,
    targettype = 32,
    desc = "选择一个随从,每当它进行攻击时,抽一张牌。",
})

function ccard12405:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard12405:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard12405:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

-- warcard
require "script.war.aux"
require "script.war.warmgr"

function ccard12405:onuse(target)
	target:addeffect("onattack",{id=self.id,sid=self.sid,})
end

function ccard12405:__onattack(attacker,defenser)
	local war = warmgr.getwar(self.warid)
	local warobj  = war:getwarobj(self.pid)
	local cardsid = warobj:pickcard()
	warobj:putinhand(cardsid)	
	return EVENTRESULT(IGNORE_NONE,IGNORE_NONE)
end

return ccard12405
