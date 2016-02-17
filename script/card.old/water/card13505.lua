--<<card 导表开始>>
local super = require "script.card.init"

ccard13505 = class("ccard13505",super,{
    sid = 13505,
    race = 3,
    name = "北郡牧师",
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
    atk = 1,
    hp = 3,
    crystalcost = 1,
    targettype = 0,
    desc = "每当一个随从获得治疗时,抽1张牌。",
})

function ccard13505:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard13505:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard13505:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end


--warcard
require "script.war.aux"
require "script.war.warmgr"

function ccard13505:onputinwar()
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	register(warobj.footman,"onaddhp",self.id)
	register(warobj.enemy.footman,"onaddhp",self.id)
end


function ccard13505:onremovefromwar()
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	unregister(warobj.footman,"onaddhp",self.id)
	unregister(warobj.enemy.footman,"onaddhp",self.id)
end

function ccard13505:__onaddhp(warcard,recoverhp)
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	local cardsid = warobj:pickcard()
	warobj:putinhand(cardsid)
	return EVENTRESULT(IGNORE_NONE,IGNORE_NONE)
end




return ccard13505
