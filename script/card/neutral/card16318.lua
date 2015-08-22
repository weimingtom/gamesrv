--<<card 导表开始>>
local super = require "script.card"

ccard16318 = class("ccard16318",super,{
    sid = 16318,
    race = 6,
    name = "圣光守护者",
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
    atk = 1,
    hp = 2,
    crystalcost = 1,
    targettype = 0,
    desc = "每当一个角色获得治疗时,便获得+2攻击力。",
})

function ccard16318:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard16318:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard16318:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

-- warcard
require "script.war.aux"
require "script.war.warmgr"

function ccard16318:onputinwar()
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	register(warobj.footman,"onaddhp",self.id)
	register(warobj.hero,"onaddhp",self.id)
	register(warobj.enemy.footman,"onaddhp",self.id)
	register(warobj.enemy.hero,"onaddhp",self.id)
end

function ccard16318:onremovefromwar()
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	unregister(warobj.footman,"onaddhp",self.id)
	unregister(warobj.hero,"onaddhp",self.id)
	unregister(warobj.enemy.footman,"onaddhp",self.id)
	unregister(warobj.enemy.hero,"onaddhp",self.id)
end

function ccard16318:__onaddhp(target,recoverhp)
	self:addbuff({addatk=2,},self.id,self.sid)
	return EVENTRESULT(IGNORE_NONE,IGNORE_NONE)
end

return ccard16318
