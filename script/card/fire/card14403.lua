--<<card 导表开始>>
local super = require "script.card"

ccard14403 = class("ccard14403",super,{
    sid = 14403,
    race = 4,
    name = "食腐土狼",
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
    type = 202,
    magic_hurt = 0,
    recoverhp = 0,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 2,
    hp = 2,
    crystalcost = 2,
    targettype = 0,
    desc = "每死1头野兽,获得+2/+1。",
})

function ccard14403:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard14403:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard14403:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

-- warcard
require "script.war.aux"
require "script.war.warmgr"

function ccard14403:onputinwar()
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	register(warobj.animal_footman,"oncheckdie",self.id)
	register(warobj.enemy.animal_footman,"oncheckdie",self.id)
end

function ccard14403:onremovefromwar()
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	unregister(warobj.animal_footman,"oncheckdie",self.id)
	unregister(warobj.enemy.animal_footman,"oncheckdie",self.id)
end

function ccard14403:__oncheckdie(warcard)
	if self.id ~= warcard.id then
		self:addbuff({addatk=2,addmaxph=1,},self.id,self.sid)
	end
	return EVENTRESULT(IGNORE_NONE,IGNORE_NONE)
end

return ccard14403
