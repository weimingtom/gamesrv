--<<card 导表开始>>
local super = require "script.card"

ccard12506 = class("ccard12506",super,{
    sid = 12506,
    race = 2,
    name = "真银之剑",
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
    atk = 4,
    hp = 2,
    crystalcost = 4,
    targettype = 0,
    desc = "每当你的英雄进攻时,为其恢复2点生命值。",
})

function ccard12506:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard12506:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard12506:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

-- warcard
require "script.war.aux"
require "script.war.warmgr"

function ccard12506:onuse(target)
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

function ccard12506:onequipweapon(hero)
	register(hero,"onattack",self.id)
end

function ccard12506:ondelweapon(hero)
	unregister(hero,"onattack",self.id)
end

function ccard12506:__onattack(attacker,defenser)
	local hero = attacker
	hero:addhp(2,self.id)
	return EVENTRESULT(IGNORE_NONE,IGNORE_NONE)
end

return ccard12506
