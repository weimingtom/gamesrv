--<<card 导表开始>>
local super = require "script.card"

ccard16530 = class("ccard16530",super,{
    sid = 16530,
    race = 6,
    name = "暗鳞先知",
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
    type = 203,
    magic_hurt = 0,
    recoverhp = 0,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 1,
    hp = 1,
    crystalcost = 1,
    targettype = 0,
    desc = "所有其他鱼人获得+1攻击力。",
})

function ccard16530:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard16530:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard16530:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

-- warcard
require "script.war.aux"
require "script.war.warmgr"

function ccard16430:onputinwar()
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	warobj.fish_footman:addhalo({addatk=1,},self.id,self.sid)
end

function ccard16430:onremovefromwar()
	local war = warmgr.getwar(self.warid)
	local warobj  = war:getwarobj(self.pid)
	warobj.fish_footman:delhalo(self.id)
end

return ccard16530
