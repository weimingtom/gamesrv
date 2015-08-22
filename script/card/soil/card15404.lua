--<<card 导表开始>>
local super = require "script.card"

ccard15404 = class("ccard15404",super,{
    sid = 15404,
    race = 5,
    name = "利爪德鲁伊",
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
    atk = 4,
    hp = 4,
    crystalcost = 5,
    targettype = 0,
    desc = "抉择：冲锋；或者+2生命值并具有嘲讽。",
})

function ccard15404:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard15404:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard15404:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

-- warcard
require "script.war.aux"
require "script.war.warmgr"

function ccard15404:onuse(target)
	if self.cancelchoice then
	else
		if self.choice == 1 then
			local cardsid = isprettycard(self.sid) and 25602 or 15602
			local warcard = warobj:newwarcard(cardsid)
			warobj:putinwar(warcard)
		elseif self.choice == 2 then
			local cardsid = isprettycard(self.sid) and 25603 or 15603
			local warcard = warobj:newwarcard(cardsid)
			warobj:putinwar(warcard)
		end
	end
end

return ccard15404
