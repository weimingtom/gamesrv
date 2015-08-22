--<<card 导表开始>>
local super = require "script.card"

ccard16116 = class("ccard16116",super,{
    sid = 16116,
    race = 6,
    name = "伊利丹·怒风",
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
    atk = 7,
    hp = 5,
    crystalcost = 6,
    targettype = 0,
    desc = "每当你使用一张牌时,召唤一个2/1的埃辛诺斯烈焰。",
})

function ccard16116:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard16116:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard16116:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

-- warcard
require "script.war.aux"
require "script.war.warmgr"

function ccard16116:onputinwar()
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	register(warobj,"onplaycard",self.id)
end

function ccard16116:onremovefromwar()
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	unregister(warobj,"onplaycard",self.id)
end

function ccard16116:__onplaycard(warcard,pos,target)
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	if #warobj.warcards < WAR_CARD_LIMIT then
		local cardsid = isprettycard(self.sid) and 26620 or 16620
		local warcard = warobj:newwarcard(cardsid)
		warobj:putinwar(warcard)
	end
	return EVENTRESULT(IGNORE_NONE,IGNORE_NONE)
end
return ccard16116
