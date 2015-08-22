--<<card 导表开始>>
local super = require "script.card"

ccard16312 = class("ccard16312",super,{
    sid = 16312,
    race = 6,
    name = "小个子召唤师",
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
    hp = 2,
    crystalcost = 2,
    targettype = 0,
    desc = "你每个回合使用的第一张随从牌的法力值消耗减少（1）点。",
})

function ccard16312:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard16312:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard16312:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end


-- warcard
require "script.war.aux"
require "script.war.warmgr"

function ccard16312:onputinwar()
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	register(warobj,"onbeginround",self.id)
end

function ccard16312:onremovefromwar()
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	unregister(warobj,"onbeginround",self.id)
	unregister(warobj,"onplaycard",self.id)
end

function ccard16312:__onbeginround(roundcnt)
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	warobj.footman_handcard:addhalo({addcrystalcost=-1,},self.id,self.sid)
	register(warobj,"onplaycard",self.id)
	return EVENTRESULT(IGNORE_NONE,IGNORE_NONE)
end

function ccard16312:__onplaycard(warcard,pos,target)
	if is_footman(warcard.type) then
		local war = warmgr.getwar(self.warid)
		local warobj = war:getwarobj(self.pid)
		warobj.footman_handcard:delhalo(self.id)
		unregister(warobj,"onplaycard",self.id)
	end
	return EVENTRESULT(IGNORE_NONE,IGNORE_NONE)
end

return ccard16312
