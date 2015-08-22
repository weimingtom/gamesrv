--<<card 导表开始>>
local super = require "script.card"

ccard16113 = class("ccard16113",super,{
    sid = 16113,
    race = 6,
    name = "游学者周卓",
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
    max_amount = 1,
    composechip = 100,
    decomposechip = 10,
    atk = 0,
    hp = 4,
    crystalcost = 2,
    targettype = 0,
    desc = "每当一个玩家施放一个法术时,复制该法术,将其置入另一个玩家的手牌。",
})

function ccard16113:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard16113:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard16113:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

-- warcard
require "script.war.aux"
require "script.war.warmgr"

function ccard16113:onputinwar()
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	register(warobj,"onplaycard",self.id)
	register(warobj.enemy,"onplaycard",self.id)
end

function ccard16113:onremovefromwar()
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	unregister(warobj,"onplaycard",self.id)
	unregister(warobj.enemy,"onplaycard",self.id)
end

function ccard16113:__onplaycard(warcard,pos,target)
	local war = warmgr.getwar(self.warid)
	local owner = war:getowner(warcard.id)
	local enemy = owner.enemy
	if is_magiccard(warcard.type) then
		enemy:putinhand(warcard.sid)
	end
	return EVENTRESULT(IGNORE_NONE,IGNORE_NONE)
end

return ccard16113
