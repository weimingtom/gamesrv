--<<card 导表开始>>
local super = require "script.card"

ccard16304 = class("ccard16304",super,{
    sid = 16304,
    race = 6,
    name = "狂野炎术师",
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
    atk = 3,
    hp = 2,
    crystalcost = 2,
    targettype = 0,
    desc = "每当你施放一个法术时,对所有随从造成1点伤害。",
})

function ccard16304:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard16304:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard16304:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

-- warcard
require "script.war.aux"
require "script.war.warmgr"

function ccard16304:onputinwar()
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	register(warobj,"onplaycard",self.id)
end

function ccard16304:onremovefromwar()
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	unregister(warobj,"onplaycard",self.id)
end

function ccard16304:__onplaycard(warcard,pos,target)
	if is_magiccard(warcard.type) then
		local war = warmgr.getwar(self.warid)
		local warobj = war:getwarobj(self.pid)
		local warcard
		for i,id in ipairs(warobj.warcards) do
			warcard = warobj.id_card[id]
			warcard:addhp(-1,self.id)
		end
		for i,id in ipairs(warobj.enemy.warcards) do
			warcard = warobj.enemy.id_card[id]
			warcard:addhp(-1,self.id)
		end
	end
	return EVENTRESULT(IGNORE_NONE,IGNORE_NONE)
end
return ccard16304
