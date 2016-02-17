--<<card 导表开始>>
local super = require "script.card.init"

ccard11304 = class("ccard11304",super,{
    sid = 11304,
    race = 1,
    name = "肯瑞托法师",
    magic_immune = 0,
    assault = 0,
    sneer = 0,
    atkcnt = 1,
    shield = 0,
    warcry = 1,
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
    hp = 3,
    crystalcost = 3,
    targettype = 23,
    desc = "战吼：在本回合中你使用的下一个奥秘的法力值消耗为0",
})

function ccard11304:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard11304:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard11304:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

-- warcard
require "script.war.aux"
require "script.war.warmgr"

function ccard11304:onuse(target)
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	warobj.secret_handcard:addhalo({setcrystalcost=0,lifecircle=1},self.id,self.sid)
	register(warobj,"onplaycard",self.id)
	register(warobj,"onendround",self.id)
end


function ccard11304:__onplaycard(warcard,pos,target)
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	if is_secretcard(warcard.sid) then
		self.isdeleffect = true
		warobj.secret_handcard:delhalo(self.id)
		unregister(warobj,"onplaycard",self.id)
		unregister(warobj,"onendround",self.id)
	end
	return EVENTRESULT(IGNORE_NONE,IGNORE_NONE)
end

function ccard11304:__onendround(roundcnt)
	if not self.isdeleffect then
		local war = warmgr.getwar(self.warid)
		local warobj = war:getwarobj(self.pid)
		warobj.secret_handcard:delhalo(self.id)
		unregister(warobj,"onplaycard",self.id)
		unregister(warobj,"onendround",self.id)
	end
	return EVENTRESULT(IGNORE_NONE,IGNORE_NONE)
end

return ccard11304
