--<<card 导表开始>>
local super = require "script.card"

ccard16109 = class("ccard16109",super,{
    sid = 16109,
    race = 6,
    name = "老瞎眼",
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
    type = 203,
    magic_hurt = 0,
    recoverhp = 0,
    max_amount = 1,
    composechip = 100,
    decomposechip = 10,
    atk = 2,
    hp = 4,
    crystalcost = 4,
    targettype = 0,
    desc = "冲锋,在战场上每有一个其他鱼人便获得+1攻击力。",
})

function ccard16109:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard16109:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard16109:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

-- warcard
require "script.war.aux"
require "script.war.warmgr"

function ccard16109:onputinwar()
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	local num = warobj.fish_footman.num + warobj.enemy.fish_footman.num
	self:addbuff({addatk=num,},self.id,self.sid)
	register(warobj.fish_footman,"onadd",self.id)
	register(warobj.enemy.fish_footman,"onadd",self.id)
	register(warobj.fish_footman,"ondel",self.id)
	register(warobj.enemy.fish_footman,"ondel",self.id)
end

function ccard16109:onremovefromwar()
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	unregister(warobj.fish_footman,"onadd",self.id)
	unregister(warobj.enemy.fish_footman,"onadd",self.id)
	unregister(warobj.fish_footman,"ondel",self.id)
	unregister(warobj.enemy.fish_footman,"ondel",self.id)
end

function ccard16109:__onadd(warcard)
	self:addbuff({addatk=1,},self.id,self.sid)
	return EVENTRESULT(IGNORE_NONE,IGNORE_NONE) 
end

function ccard16109:__ondel(warcard)
	self:addbuff({addatk=-1,},self.id,self.sid)
	return EVENTRESULT(IGNORE_NONE,IGNORE_NONE)
end


return ccard16109
