--<<card 导表开始>>
local super = require "script.card"

ccard16410 = class("ccard16410",super,{
    sid = 16410,
    race = 6,
    name = "恶毒铁匠",
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
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 4,
    hp = 6,
    crystalcost = 5,
    targettype = 0,
    desc = "激怒：你的武器获得+2攻击力。",
})

function ccard16410:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard16410:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard16410:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

-- warcard
require "script.war.aux"
require "script.war.warmgr"

function ccard16410:onenrage()
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	local weapon = warobj.hero:getweapon()
	if weapon then
		warobj.hero:addweaponatk(2)
	end
end

function ccard16410:onunenrage()
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	local weapon = warobj.hero:getweapon()
	if weapon then
		warobj.hero:addweaponatk(-2)
	end
end

function ccard16410:onputinwar()
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	register(warobj.hero,"onequipweapon",self.id)	
end

function ccard16410:onremovefromwar()
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	unregister(warobj.hero,"onequipweapon",self.id)
	if self:getstate("enrage") then
		local weapon = warobj.hero:getweapon()
		if weapon then
			warobj.hero:addweaponatk(-2)
		end
	end
end

function ccard16410:__onequipweapon(hero)
	hero:addweaponatk(2)
	return EVENTRESULT(IGNORE_NONE,IGNORE_NONE)
end

return ccard16410
