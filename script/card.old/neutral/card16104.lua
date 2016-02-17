--<<card 导表开始>>
local super = require "script.card.init"

ccard16104 = class("ccard16104",super,{
    sid = 16104,
    race = 6,
    name = "比斯巨兽",
    magic_immune = 0,
    assault = 0,
    sneer = 0,
    atkcnt = 1,
    shield = 0,
    warcry = 0,
    dieeffect = 1,
    secret = 0,
    sneak = 0,
    magic_hurt_adden = 0,
    type = 201,
    magic_hurt = 0,
    recoverhp = 0,
    max_amount = 1,
    composechip = 100,
    decomposechip = 10,
    atk = 10,
    hp = 6,
    crystalcost = 6,
    targettype = 0,
    desc = "亡语：为你的对手召唤1个3/3的芬克·恩霍尔。",
})

function ccard16104:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard16104:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard16104:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

-- warcard
require "script.war.aux"
require "script.war.warmgr"

function ccard16104:ondie()
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	local cardsid = isprettycard(self.sid) and 26615 or 16615
	local warcard = warobj.enemy:newwarcard(cardsid)
	warobj.enemy:putinwar(warcard)
end

return ccard16104
