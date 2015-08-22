--<<card 导表开始>>
local super = require "script.card"

ccard16406 = class("ccard16406",super,{
    sid = 16406,
    race = 6,
    name = "风险投资公司雇佣兵",
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
    atk = 7,
    hp = 6,
    crystalcost = 5,
    targettype = 0,
    desc = "你的随从牌的法力值消耗增加（3）点。",
})

function ccard16406:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard16406:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard16406:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

-- warcard
require "script.war.aux"
require "script.war.warmgr"

function ccard16406:onputinwar()
	local war = warmgr.getwar(self.warid)
	local warobj  = war:getwarobj(self.pid)
	warobj.footman_handcard:addhalo({addcrystalcost=3,},self.id,self.sid)
end

function ccard16406:onremovefromwar()
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	warobj.footman_handcard:delhalo(self.id)
end

return ccard16406
