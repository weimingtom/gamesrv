--<<card 导表开始>>
local super = require "script.card.init"

ccard16431 = class("ccard16431",super,{
    sid = 16431,
    race = 6,
    name = "恐怖海盗",
    magic_immune = 0,
    assault = 0,
    sneer = 1,
    atkcnt = 1,
    shield = 0,
    warcry = 0,
    dieeffect = 0,
    secret = 0,
    sneak = 0,
    magic_hurt_adden = 0,
    type = 204,
    magic_hurt = 0,
    recoverhp = 0,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 3,
    hp = 3,
    crystalcost = 4,
    targettype = 0,
    desc = "嘲讽。消耗降低,降低数值相当于你的武器攻击。",
})

function ccard16431:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard16431:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard16431:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

-- warcard
require "script.war.aux"
require "script.war.warmgr"

function ccard16431:onputinhand()
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	local weapon = warobj.hero:getweapon()
	if weapon then
		self:addbuff({addcrystalcost=-weapon.atk},weapon.id,weapon.sid)
	end
	register(warobj.hero,"onequipweapon",self.id)
	register(warobj.hero,"ondelweapon",self.id)
end

function ccard16431:onremovefromhand()
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	unregister(warobj.hero,"onequipweapon",self.id)
	unregister(warobj.hero,"ondelweapon",self.id)
end

function ccard16431:__onequipweapon(hero)
	local weapon = hero:getweapon()
	self:addbuff({addcrystalcost=-weapon.atk},weapon.id,weapon.sid)
	return EVENTRESULT(IGNORE_NONE,IGNORE_NONE)
end

function ccard16431:__ondelweapon(hero)
	local weapon = hero:getweapon()
	self:delbuff(weapon.id)
	return EVENTRESULT(IGNORE_NONE,IGNORE_NONE)
end


return ccard16431
