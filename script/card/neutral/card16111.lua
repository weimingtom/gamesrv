--<<card 导表开始>>
local super = require "script.card.init"

ccard16111 = class("ccard16111",super,{
    sid = 16111,
    race = 6,
    name = "米尔豪斯·法力风暴",
    magic_immune = 0,
    assault = 0,
    sneer = 0,
    atkcnt = 1,
    shield = 0,
    warcry = 1,
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
    atk = 4,
    hp = 4,
    crystalcost = 2,
    targettype = 0,
    desc = "战吼：下个回合敌方法术的法力值消耗为（0）点。",
})

function ccard16111:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard16111:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard16111:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

-- warcard
require "script.war.aux"
require "script.war.warmgr"

-- may modify
function ccard16111:onuse(target)
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	warobj.enemy.magic_handcard:addhalo({setcrystalcost=0,lifecircle=1,},self.id,self.sid)
end

return ccard16111
