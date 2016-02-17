--<<card 导表开始>>
local super = require "script.card.init"

ccard11101 = class("ccard11101",super,{
    sid = 11101,
    race = 1,
    name = "大法师安东尼达斯",
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
    hp = 7,
    crystalcost = 7,
    targettype = 23,
    desc = "每当你施放一个法术时,将一张‘火球术’置入你的手牌",
})

function ccard11101:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard11101:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard11101:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end


-- warcard
require "script.war.aux"
require "script.war.warmgr"

function ccard11101:onputinwar()
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	register(warobj,"onplaycard",self.id)
end

function ccard11101:onremovefromwar()
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	unregister(warobj,"onplaycard",self.id)
end

function ccard11101:__onplaycard(warcard,pos,target)
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	if is_magiccard(warcard.type) then
		local cardsid = isprettycard(self.sid) and 21502 or 11502
		warobj:putinhand(cardsid)
	end	
	return EVENTRESULT(IGNORE_NONE,IGNORE_NONE)
end

return ccard11101
