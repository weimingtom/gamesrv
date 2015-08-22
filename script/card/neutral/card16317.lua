--<<card 导表开始>>
local super = require "script.card"

ccard16317 = class("ccard16317",super,{
    sid = 16317,
    race = 6,
    name = "魔瘾者",
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
    hp = 3,
    crystalcost = 2,
    targettype = 0,
    desc = "在本回合中,每当你施放一个法术,便获得+2攻击力。",
})

function ccard16317:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard16317:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard16317:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

-- warcard
require "script.war.aux"
require "script.war.warmgr"

function ccard16317:onputinwar()
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	register(warobj,"onplaycard",self.id)
	register(warobj,"onendround",self.id)
end

function ccard16317:onremovefromwar()
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	unregister(warobj,"onplaycard",self.id)
	unregister(warobj,"onendround",self.id)
end

function ccard16317:__onplaycard(warcard,pos,target)
	if is_magiccard(warcard.type) then
		self:addbuff({addatk=2,},self.id,self.sid)
	end
	return EVENTRESULT(IGNORE_NONE,IGNORE_NONE)
end

function ccard16317:__onendround(roundcnt)
	self:delbuff(self.id)
	return EVENTRESULT(IGNORE_NONE,IGNORE_NONE)
end

return ccard16317
