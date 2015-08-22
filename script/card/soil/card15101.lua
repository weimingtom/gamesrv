--<<card 导表开始>>
local super = require "script.card"

ccard15101 = class("ccard15101",super,{
    sid = 15101,
    race = 5,
    name = "塞纳留斯",
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
    max_amount = 1,
    composechip = 100,
    decomposechip = 10,
    atk = 5,
    hp = 8,
    crystalcost = 9,
    targettype = 0,
    desc = "抉择：使你的所有其他随从获得+2/+2；或者召唤2个2/2并具有嘲讽的树人。",
})

function ccard15101:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard15101:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard15101:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

-- warcard
require "script.war.aux"
require "script.war.warmgr"

function ccard15101:onuse(target)
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	local warcard
	if self.choice == 1 then
		for i,id in ipairs(warobj.warcards) do
			warcard = warobj.id_card[id]
			warcard:addbuff({addatk=2,addmaxhp=2,},self.id,self.sid)
		end
	elseif self.chioce == 2 then
		local cardsid = isprettycard(self.sid) and 25604 or 15604
		warcard = warobj:newwarcard(cardsid)
		warobj:putinwar(warcard,self.pos-1)
		warcard = warobj:newwarcard(cardsid)
		warobj:putinwar(warcard,self.pos+1)
	end
end

return ccard15101
