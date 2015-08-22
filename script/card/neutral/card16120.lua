--<<card 导表开始>>
local super = require "script.card"

ccard16120 = class("ccard16120",super,{
    sid = 16120,
    race = 6,
    name = "死亡之翼",
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
    max_amount = 1,
    composechip = 100,
    decomposechip = 10,
    atk = 12,
    hp = 12,
    crystalcost = 10,
    targettype = 0,
    desc = "战吼：消灭所有其他随从,并弃掉你的手牌。",
})

function ccard16120:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard16120:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard16120:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

-- warcard

require "script.war.aux"
require "script.war.warmgr"

function ccard16120:onuse(target)
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	local warcard
	local ids = copy(warobj.warcards)
	for _,id in ipairs(ids) do
		warcard = warobj.id_card[id]
		warobj:removefromwar(warcard)
	end
	ids = copy(warobj.warcards)
	for _,id in ipairs(ids) do
		warcard = warobj.enemy.id_card[id]
		warobj.enemy:removefromwar(warcard)
	end
	warobj:clearhandcard()
end


return ccard16120
