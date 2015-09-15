--<<card 导表开始>>
local super = require "script.card.init"

ccard14401 = class("ccard14401",super,{
    sid = 14401,
    race = 4,
    name = "关门放狗",
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
    crystalcost = 3,
    targettype = 0,
    desc = "战场上每有一个敌方随从,便召唤一个1/1并具有冲锋的猎犬。",
})

function ccard14401:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard14401:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard14401:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end


-- warcard
require "script.war.aux"
require "script.war.warmgr"

function ccard14401:onuse(target)
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	local num = #warobj.enemy.warcards
	local cardsid = isprettycard(self.sid) and 24601 or 14601
	for i = 1,num do
		local warcard = warobj:newwarcard(cardsid)	
		if not warobj:putinwar(warcard) then
			break
		end
	end
end

return ccard14401
