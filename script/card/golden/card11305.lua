--<<card 导表开始>>
local super = require "script.card"

ccard11305 = class("ccard11305",super,{
    sid = 11305,
    race = 1,
    name = "蒸发",
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
    desc = "奥秘：当一个随从攻击你英雄时,将其消灭",
})

function ccard11305:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard11305:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard11305:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

-- warcard
require "script.war.aux"
require "script.war.warmgr"

function ccard11305:onuse(target)
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	warobj:addsecret(self.id)
	register(warobj.hero,"ondefense",self.id)
end

function ccard11305:__ondefense(attacker)
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	if is_footman(attacker.type) then
		warobj:delsecret(self.id,"trigger")
		unregister(warobj.hero,"ondefense",self.id)
		attacker:setdie()
		return EVENTRESULT(IGNORE_ACTION,IGNORE_NONE)
	end
	return EVENTRESULT(IGNORE_NONE,IGNORE_NONE)
end

return ccard11305
