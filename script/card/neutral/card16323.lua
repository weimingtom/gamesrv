--<<card 导表开始>>
local super = require "script.card"

ccard16323 = class("ccard16323",super,{
    sid = 16323,
    race = 6,
    name = "帝王眼镜蛇",
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
    atk = 2,
    hp = 3,
    crystalcost = 3,
    targettype = 0,
    desc = "消灭任何受到该随从伤害的随从。",
})

function ccard16323:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard16323:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard16323:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end


-- warcard
require "script.war.aux"
require "script.war.warmgr"

function ccard16323:onputinwar()
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	register(warobj.footman,"onhurt",self.id)
	register(warobj.enemy.footman,"onhurt",self.id)
end

function ccard16323:onremovefromwar()
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	unregister(warobj.footman,"onhurt",self.id)
	unregister(warobj.enemy.footman,"onhurt",self.id)
end

function ccard16323:__onhurt(warcard,hurtvalue,srcid)
	if srcid == self.id then
		warcard:setdie()
	end
	return EVENTRESULT(IGNORE_NONE,IGNORE_NONE)
end


return ccard16323
