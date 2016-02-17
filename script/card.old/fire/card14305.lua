--<<card 导表开始>>
local super = require "script.card.init"

ccard14305 = class("ccard14305",super,{
    sid = 14305,
    race = 4,
    name = "鹰角弓",
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
    type = 301,
    magic_hurt = 0,
    recoverhp = 0,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 3,
    hp = 2,
    crystalcost = 3,
    targettype = 0,
    desc = "每触发1个奥秘,获得+1耐久。",
})

function ccard14305:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard14305:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard14305:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

-- warcard
require "script.war.aux"
require "script.war.warmgr"

function ccard14305:onuse(target)
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	local weapon = {
		id = self.id,
		sid = self.sid,
		atk = self.atk,
		usecnt = self.hp,
		atkcnt = self.atkcnt,
	}
	warobj.hero:equipweapon(weapon)
end

function ccard14305:onequipweapon(hero)
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	register(warobj,"ontriggersecret",self.id)
end

function ccard14305:ondelweapon(hero)
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	unregister(warobj,"ontriggersecret",self.id)
end

function ccard14305:__ontriggersecret(secretcardid)
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	warobj.hero:addweaponusecnt(1)
	return EVENTRESULT(IGNORE_NONE,IGNORE_NONE)
end

return ccard14305
