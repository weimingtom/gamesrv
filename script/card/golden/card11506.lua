--<<card 导表开始>>
local super = require "script.card.init"

ccard11506 = class("ccard11506",super,{
    sid = 11506,
    race = 1,
    name = "水元素",
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
    atk = 3,
    hp = 6,
    crystalcost = 4,
    targettype = 23,
    desc = "冻结任何受到水元素伤害的角色",
})

function ccard11506:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard11506:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard11506:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

-- warcard
require "script.war.aux"
require "script.war.warmgr"

function ccard11506:onputinwar()
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	register(warobj.hero,"onhurt",self.id)
	register(warobj.footman,"onhurt",self.id)
	register(warobj.enemy.hero,"onhurt",self.id)
	register(warobj.enemy.footman,"onhurt",self.id)
end

function ccard11506:onremovefromwar()
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	unregister(warobj.hero,"onhurt",self.id)
	unregister(warobj.footman,"onhurt",self.id)
	unregister(warobj.enemy.hero,"onhurt",self.id)
	unregister(warobj.enemy.footman,"onhurt",self.id)
end

function ccard11506:__onhurt(obj,hurtvalue,srcid)
	if srcid == self.id then
		obj:setstate("freeze",1)
	end
	return EVENTRESULT(IGNORE_NONE,IGNORE_NONE)
end


return ccard11506
