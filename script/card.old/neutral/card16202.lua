--<<card 导表开始>>
local super = require "script.card.init"

ccard16202 = class("ccard16202",super,{
    sid = 16202,
    race = 6,
    name = "海巨人",
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
    crystalcost = 10,
    targettype = 0,
    desc = "战场上每有一个其他随从,该牌的法力值消耗便减少（1）点。",
})

function ccard16202:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard16202:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard16202:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

-- warcard
require "script.war.aux"
require "script.war.warmgr"

function ccard16202:onputinhand()
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	local num = warobj.footman.num + warobj.enemy.footman.num
	self:addbuff({addcrystalcost=-num,},self.id,self.sid)
	register(warobj.footman,"onadd",self.id)
	register(warobj.footman,"ondel",self.id)
	register(warobj.enemy.footman,"onadd",self.id)
	register(warobj.enemy.footman,"ondel",self.id)
end

function ccard16202:onremovefromhand()
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	unregister(warobj.footman,"onadd",self.id)
	unregister(warobj.footman,"ondel",self.id)
	unregister(warobj.enemy.footman,"onadd",self.id)
	unregister(warobj.enemy.footman,"ondel",self.id)
end

function ccard16202:__onadd(warcard)
	self:addbuff({addcrystalcost=-1,},self.id,self.sid)
	return EVENTRESULT(IGNORE_NONE,IGNORE_NONE)
end

function ccard16202:__ondel(warcard)
	self:addbuff({addcrystalcost=1,},self.id,self.sid)
	return EVENTRESULT(IGNORE_NONE,IGNORE_NONE)
end


return ccard16202
