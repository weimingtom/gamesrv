--<<card 导表开始>>
local super = require "script.card"

ccard14506 = class("ccard14506",super,{
    sid = 14506,
    race = 4,
    name = "苔原犀牛",
    magic_immune = 0,
    assault = 1,
    sneer = 0,
    atkcnt = 1,
    shield = 0,
    warcry = 0,
    dieeffect = 0,
    secret = 0,
    sneak = 0,
    magic_hurt_adden = 0,
    type = 202,
    magic_hurt = 0,
    recoverhp = 0,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 2,
    hp = 5,
    crystalcost = 5,
    targettype = 0,
    desc = "使你的野兽获得冲锋。",
})

function ccard14506:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard14506:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard14506:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end


-- warcard
require "script.war.aux"
require "script.war.warmgr"

function ccard14506:onputinwar()
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	warobj.animal_footman:setstate("assault",1)
	register(warobj.animal_footman,"onadd",self.id)
end

function ccard14506:onremovefromwar()
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	unregister(warobj.animal_footman,"onadd",self.id)
end

function ccard14506:__onadd(warcard)
	warcard:setstate("assault",1)
	return EVENTRESULT(IGNORE_NONE,IGNORE_NONE)
end

return ccard14506
