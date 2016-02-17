--<<card 导表开始>>
local super = require "script.card.init"

ccard12201 = class("ccard12201",super,{
    sid = 12201,
    race = 2,
    name = "公正之剑",
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
    atk = 1,
    hp = 5,
    crystalcost = 3,
    targettype = 0,
    desc = "每当你召唤一个随从,使它获得+1/+1,这把武器失去1点耐久度。",
})

function ccard12201:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard12201:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard12201:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

-- warcard
require "script.war.aux"
require "script.war.warmgr"

function ccard12201:onequipweapon(hero)
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(hero.pid)
	register(warobj.footman,"onadd",self.id)
end

function ccard12201:ondelweapon(hero)
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(hero.pid)
	unregister(warobj.footman,"onadd",self.id)
end

function ccard12201:onuse(target)
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

function ccard12201:__onadd(warcard)
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	warobj.hero:addweaponusecnt(-1)
	warcard:addbuff({addmaxhp=1,addatk=1,},self.id,self.sid)
	return EVENTRESULT(IGNORE_NONE,IGNORE_NONE)
end


return ccard12201
