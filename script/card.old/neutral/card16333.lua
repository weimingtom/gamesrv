--<<card 导表开始>>
local super = require "script.card.init"

ccard16333 = class("ccard16333",super,{
    sid = 16333,
    race = 6,
    name = "报警机器人",
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
    hp = 3,
    crystalcost = 3,
    targettype = 0,
    desc = "在你的回合开始时,随机将你的手牌中的一张随从牌与该随从交换。",
})

function ccard16333:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard16333:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard16333:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

-- warcard
require "script.war.aux"
require "script.war.warmgr"

function ccard16333:onbeginround(roundcnt)
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	local hitids = warobj.footman_handcard:allid()
	warobj:removefromwar(self)
	warobj:putinhand(self.sid)
	if #hitids > 0 then
		local id = randlist(hitids)
		local warcard = warobj.id_card[id]
		warobj:removefromhand(warcard)
		warobj:putinwar(warcard,self.pos)
	end
end

return ccard16333
