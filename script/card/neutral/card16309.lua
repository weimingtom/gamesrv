--<<card 导表开始>>
local super = require "script.card"

ccard16309 = class("ccard16309",super,{
    sid = 16309,
    race = 6,
    name = "狂奔科多兽",
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
    atk = 3,
    hp = 5,
    crystalcost = 5,
    targettype = 22,
    desc = "战吼：随机消灭一个攻击力小于或等于2的敌方随从。",
})

function ccard16309:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard16309:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard16309:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

-- warcard
require "script.war.aux"
require "script.war.warmgr"

function ccard16309:onuse(target)
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	local warcard
	local hitids = {}
	for i,id in ipairs(warobj.enemy.warcards) do
		warcard = warobj.enemy.id_card[id]
		if warcard:getatk() <= 2 then
			table.insert(hitids,id)
		end
	end
	if #hitids > 0 then
		local id = randlist(hitids)
		warcard = warobj.enemy.id_card[id]
		warcard:setdie()
	end
end

return ccard16309
