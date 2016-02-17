--<<card 导表开始>>
local super = require "script.card.init"

ccard16208 = class("ccard16208",super,{
    sid = 16208,
    race = 6,
    name = "末日预言者",
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
    atk = 0,
    hp = 7,
    crystalcost = 2,
    targettype = 0,
    desc = "在你的回合开始时,消灭所有随从。",
})

function ccard16208:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard16208:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard16208:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

-- warcard

require "script.war.aux"
require "script.war.warmgr"

function ccard16208:onendround(roundcnt)
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	local warcard
	local ids = copy(warobj.warcards)
	for i,id in ipairs(ids) do
		warcard = warobj.id_card[id]
		warobj:removefromwar(warcard)
	end
	ids = copy(warobj.enemy.warcards)
	for i,id in ipairs(ids) do
		warcard = warobj.enemy.id_card[id]
		warobj.enemy:removefromwar(warcard)
	end
end

return ccard16208
