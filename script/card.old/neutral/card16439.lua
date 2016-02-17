--<<card 导表开始>>
local super = require "script.card.init"

ccard16439 = class("ccard16439",super,{
    sid = 16439,
    race = 6,
    name = "腐食食尸鬼",
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
    desc = "每当一个随从死亡时,获得+1攻击力。",
})

function ccard16439:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard16439:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard16439:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

-- warcard
require "script.war.aux"
require "script.war.warmgr"

function ccard16439:onputinwar()
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	register(warobj.footman,"ondie",self.id)
	register(warobj.enemy.footman,"ondie",self.id)
end

function ccard16439:onremovefromwar()
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	unregister(warobj.footman,"ondie",self.id)
	unregister(warobj.enemy.footman,"ondie",self.id)
end

function ccard16439:__ondie()
	self:addbuff({addatk=1,},self.id,self.sid)
	return EVENTRESULT(IGNORE_NONE,IGNORE_NONE)
end

return ccard16439
