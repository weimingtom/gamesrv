--<<card 导表开始>>
local super = require "script.card.init"

ccard16612 = class("ccard16612",super,{
    sid = 16612,
    race = 6,
    name = "梦境",
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
    crystalcost = 0,
    targettype = 32,
    desc = "使一名仆从回到其拥有者的手牌中。",
})

function ccard16612:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard16612:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard16612:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

-- warcard
require "script.war.aux"
require "script.war.warmgr"

function ccard16612:onuse(target)
	local war = warmgr.getwar(target.warid)
	local warobj = war:getwarobj(target.pid)
	warobj:removefromwar(target)
	warobj:putinhand(target.sid)
end

return ccard16612
