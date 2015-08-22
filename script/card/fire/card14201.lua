--<<card 导表开始>>
local super = require "script.card"

ccard14201 = class("ccard14201",super,{
    sid = 14201,
    race = 4,
    name = "毒蛇陷阱",
    magic_immune = 0,
    assault = 0,
    sneer = 0,
    atkcnt = 0,
    shield = 0,
    warcry = 0,
    dieeffect = 0,
    secret = 1,
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
    desc = "奥秘：当你的1个随从遭到攻击时,召唤3条1/1毒蛇。",
})

function ccard14201:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard14201:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard14201:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

-- warcard
require "script.war.aux"
require "script.war.warmgr"

function ccard14201:onuse(target)
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	warobj:addsecret(self.id)
	register(warobj.footman,"ondefense",self.id)
end

function ccard14201:__ondefense(attacker,defenser)
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	warobj:delsecret(self.id,"trigger")
	unregister(warobj.footman,"ondefense",self.id)
	for i = 1,3 do
		local cardsid = isprettycard(self.sid) and 24606 or 14606
		local warcard = warobj:newwarcard(cardsid)
		warobj:putinwar(warcard)
	end
	return EVENTRESULT(IGNORE_NONE,IGNORE_NONE)
end

return ccard14201
