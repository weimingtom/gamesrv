--<<card 导表开始>>
local super = require "script.card.init"

ccard15203 = class("ccard15203",super,{
    sid = 15203,
    race = 5,
    name = "知识古树",
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
    recoverhp = 5,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 5,
    hp = 5,
    crystalcost = 7,
    targettype = 0,
    desc = "抉择：抽2张牌；或恢复5点生命值。",
})

function ccard15203:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard15203:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard15203:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

-- warcard
require "script.war.aux"
require "script.war.warmgr"

function ccard15203:onuse(target)
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	if self.choice == 1 then
		for i = 1, 2 do
			local cardsid = warobj:pickcard()
			warobj:putinhand(cardsid)
		end
	elseif self.choice == 2 then
		local recoverhp = self:getrecoverhp()
		target:addhp(recoverhp,self.id)
	end
end

return ccard15203
