--<<card 导表开始>>
local super = require "script.card"

ccard16435 = class("ccard16435",super,{
    sid = 16435,
    race = 6,
    name = "诅咒教派领袖",
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
    hp = 2,
    crystalcost = 4,
    targettype = 0,
    desc = "每当你的其他随从死亡时,抽一张牌。",
})

function ccard16435:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard16435:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard16435:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

-- warcard
require "script.war.aux"
require "script.war.warmgr"

function ccard16435:onputinwar()
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	register(warobj.footman,"oncheckdie",self.id)
end

function ccard16435:onremovefromwar()
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	unregister(warobj.footman,"oncheckdie",self.id)
end

function ccard16435:__oncheckdie(warcard)
	if self.id ~= warcard.id then
		local war = warmgr.getwar(self.warid)
		local warobj = war:getwarobj(self.pid)
		local cardsid = warobj:pickcard()
		warobj:putinhand(cardsid)
	end
	return EVENTRESULT(IGNORE_NONE,IGNORE_NONE)
end

return ccard16435
