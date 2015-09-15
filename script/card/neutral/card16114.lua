--<<card 导表开始>>
local super = require "script.card.init"

ccard16114 = class("ccard16114",super,{
    sid = 16114,
    race = 6,
    name = "火车王里诺艾",
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
    type = 201,
    magic_hurt = 0,
    recoverhp = 0,
    max_amount = 1,
    composechip = 100,
    decomposechip = 10,
    atk = 6,
    hp = 2,
    crystalcost = 5,
    targettype = 0,
    desc = "冲锋,战吼：为你的对手召唤2只1/1的雏龙。",
})

function ccard16114:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard16114:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard16114:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

-- warcard
require "script.war.aux"
require "script.war.warmgr"

function ccard16114:onuse(target)
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	local cardsid = isprettycard(self.sid) and 26619 or 16619
	for i = 1,2 do
		if #warobj.enemy.warcards >= WAR_CARD_LIMIT then
			break
		end
		local warcard = warobj.enemy:newwarcard(cardsid)
		warobj.enemy:putinwar(warcard)
	end
end

return ccard16114
