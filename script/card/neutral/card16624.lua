--<<card 导表开始>>
local super = require "script.card.init"

ccard16624 = class("ccard16624",super,{
    sid = 16624,
    race = 6,
    name = "导航小鸡",
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
    type = 206,
    magic_hurt = 0,
    recoverhp = 0,
    max_amount = 0,
    composechip = 0,
    decomposechip = 0,
    atk = 0,
    hp = 1,
    crystalcost = 1,
    targettype = 0,
    desc = "在你的回合开始阶段,消灭该随从,并抽3张牌。",
})

function ccard16624:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard16624:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard16624:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

-- warcard
require "script.war.aux"
require "script.war.warmgr"

function ccard16624:onbeginround(roundcnt)
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	warobj:removefromwar(self)
	for i = 1,3 do
		local cardsid = warobj:pickcard()
		warobj:putinhand(cardsid)
	end
end

return ccard16624
