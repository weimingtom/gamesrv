--<<card 导表开始>>
local super = require "script.card.init"

ccard14503 = class("ccard14503",super,{
    sid = 14503,
    race = 4,
    name = "多重射击",
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
    magic_hurt = 3,
    recoverhp = 0,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 0,
    hp = 0,
    crystalcost = 4,
    targettype = 0,
    desc = "随机对2名敌对随从造成3点伤害。",
})

function ccard14503:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard14503:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard14503:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

-- warcard
require "script.war.aux"
require "script.war.warmgr"

function ccard14503:onuse(target)
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	local i = 1
	local num = math.min(#warobj.enemy.warcards,2)
	local hitids = {}
	while i <= num do
		local id = randlist(warobj.enemy.warcards)	
		if not hitids[id] then
			hitids[id] = true
			i = i + 1
		end
	end
	local hurtvalue = self:gethurtvalue()
	for id,_ in pairs(hitids) do
		local warcard = warobj.enemy.id_card[id]
		warcard:addhp(-hurtvalue,self.id)
	end
end

return ccard14503
