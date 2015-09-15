--<<card 导表开始>>
local super = require "script.card.init"

ccard16204 = class("ccard16204",super,{
    sid = 16204,
    race = 6,
    name = "山岭巨人",
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
    atk = 8,
    hp = 8,
    crystalcost = 12,
    targettype = 0,
    desc = "你每有一张其他手牌,该牌的法力值消耗便减少（1）点。",
})

function ccard16204:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard16204:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard16204:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

-- warcard
require "script.war.aux"
require "script.war.warmgr"

function ccard16204:onputinhand()
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	local num = #warobj.handcards
	self:addbuff({addcrystalcost=-num},self.id,self.sid)
	register(warobj,"onputinhand",self.id)
	register(warobj,"onremovefromhand",self.id)
end

function ccard16204:onremovefromhand()
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	unregister(warobj,"onputinhand",self.id)
	unregister(warobj,"onremovefromhand",self.id)
end

function ccard16204:__onputinhand(warcard)
	self:addbuff({addcrystalcost=-1,},self.id,self.sid)
	return EVENTRESULT(IGNORE_NONE,IGNORE_NONE)
end

function ccard16204:__onremovefromhand(warcard)
	self:addbuff({addcrystalcost=1,},self.id,self.sid)
	return EVENTRESULT(IGNORE_NONE,IGNORE_NONE)
end

return ccard16204
