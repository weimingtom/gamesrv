--<<card 导表开始>>
local super = require "script.card"

ccard11405 = class("ccard11405",super,{
    sid = 11405,
    race = 1,
    name = "镜像实体",
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
    crystalcost = 3,
    targettype = 0,
    desc = "奥秘：当你的对手打出一张随从牌时,召唤一个该随从的复制",
})

function ccard11405:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard11405:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard11405:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

-- warcard
require "script.war.aux"
require "script.war.warmgr"
require "script.war.warcard"

function ccard11405:onuse(target)
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	warobj:addsecret(self.id)
	register(warobj.enemy,"onplaycard",self.id)
end

function ccard11405:__onplaycard(warcard,pos,target)
	if is_footman(warcard.type) then
		local war = warmgr.getwar(self.warid)
		local warobj = war:getwarobj(self.pid)
		warobj:delsecret(self.id,"trigger")
		unregister(warobj.enemy,"onplaycard",self.id)
		local copy_warcard = warobj:newwarcard(warcard.sid)
		warobj:putinwar(copy_warcard)
	end
	return EVENTRESULT(IGNORE_NONE,IGNORE_NONE)
end

return ccard11405
