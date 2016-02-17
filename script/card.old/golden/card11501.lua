--<<card 导表开始>>
local super = require "script.card.init"

ccard11501 = class("ccard11501",super,{
    sid = 11501,
    race = 1,
    name = "变形术",
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
    crystalcost = 4,
    targettype = 22,
    desc = "将一个仆从变成一个1/1的羊",
})

function ccard11501:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard11501:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard11501:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

-- warcard
require "script.war.aux"
require "script.war.warmgr"

function ccard11501:onuse(target)
	local war = warmgr.getwar(self.warid)
	local owner = war:getowner(target.id)
	local pos = target.pos
	local cardsid = isprettycard(target.sid) and 21602 or 11602
	local warcard = owner:newwarcard(cardsid)
	owner:removefromwar(target)
	owner:putinwar(warcard,pos)
	
end

return ccard11501
