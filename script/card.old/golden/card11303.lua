--<<card 导表开始>>
local super = require "script.card.init"

ccard11303 = class("ccard11303",super,{
    sid = 11303,
    race = 1,
    name = "法术反制",
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
    desc = "奥秘：当你的对手施放法术时,法制该法术",
})

function ccard11303:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard11303:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard11303:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

-- warcard
require "script.war.aux"
require "script.war.warmgr"

function ccard11303:__onplaycard(warcard,pos,target)
	if is_magiccard(warcard.type) then
		local war = warmgr.getwar(self.warid)	
		local warobj = war:getwarobj(self.pid)
		warobj:delsecret(self.id,"trigger")
		unregister(warobj.enemy,"onplaycard",self.id)
		return EVENTRESULT(IGNORE_ACTION,IGNORE_NONE)
	end
	return EVENTRESULT(IGNORE_NONE,IGNORE_NONE)
end

function ccard11303:onuse(target)
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	warobj:addsecret(self.id)
	register(warobj.enemy,"onplaycard",self.id)
end

return ccard11303
