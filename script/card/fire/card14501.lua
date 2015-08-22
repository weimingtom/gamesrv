--<<card 导表开始>>
local super = require "script.card"

ccard14501 = class("ccard14501",super,{
    sid = 14501,
    race = 4,
    name = "追踪术",
    magic_immune = 0,
    assault = 0,
    sneer = 0,
    atkcnt = 0,
    shield = 0,
    warcry = 0,
    dieeffect = 0,
    secret = 0,
    sneak = 0,
    magic_hurt_adden = 0,
    type = 101,
    magic_hurt = 0,
    recoverhp = 0,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 0,
    hp = 0,
    crystalcost = 1,
    targettype = 0,
    desc = "查看你卡堆顶部的3张牌,抽取1张,弃掉其它2张。",
})

function ccard14501:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard14501:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard14501:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end


-- warcard
require "script.war.aux"
require "script.war.warmgr"

function ccard14501:onuse(target)
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	local num = math.min(#warobj.leftcards,3)
	local lookcards = {}
	for i = 1,num do
		table.insert(lookcards,table.remove(warobj.leftcards))
	end
	warobj.lookcards = lookcards
	warmgr.refreshwar(self.warid,self.pid,"lookcards",{sids=lookcards,})
end

return ccard14501
