--<<card 导表开始>>
local super = require "script.card"

ccard15402 = class("ccard15402",super,{
    sid = 15402,
    race = 5,
    name = "野性之力",
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
    crystalcost = 2,
    targettype = 0,
    desc = "抉择：使你的随从获得+1/+1；或者召唤一个3/2的猎豹。",
})

function ccard15402:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard15402:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard15402:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

-- warcard
require "script.war.aux"
require "script.war.warmgr"

function ccard15402:onuse(target)
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	if self.choice == 1 then
		for i,id in ipairs(warobj.warcards) do
			local warcard = warobj.id_card[id]
			warcard:addbuff({addatk=1,addmaxhp=1,},self.id,self.sid)
		end
	elseif self.choice == 2 then
		local cardsid = isprettycard(self.sid) and 25601 or 15601
		local warcard = warobj:newwarcard(cardsid)
		warobj:putinwar(warcard)
	end
end

return ccard15402
