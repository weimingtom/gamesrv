--<<card 导表开始>>
local super = require "script.card.init"

ccard143001 = class("ccard143001",super,{
    sid = 143001,
    race = 4,
    name = "长鬃草原狮",
    type = 202,
    magic_immune = 0,
    assault = 0,
    sneer = 0,
    atkcnt = 1,
    shield = 0,
    warcry = 0,
    dieeffect = 1,
    sneak = 0,
    magic_hurt_adden = 0,
    magic_hurt = 0,
    recoverhp = 0,
    cure_to_hurt = 0,
    recoverhp_multi = 1,
    magic_hurt_multi = 1,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 6,
    hp = 5,
    crystalcost = 6,
    targettype = 0,
    desc = "亡语：召唤2只2/2土狼。",
})

function ccard143001:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard143001:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard143001:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

function ccard143001:ondie()
	local owner = self:getowner()
	local pos = self.pos
	local sid = is_goldcard(self.sid) and 24602 or 14602
	for i=1 2 do
		local warcard = owner:newwarcard(sid)
		owner:putinwar(warcard,pos)
	end
end

return ccard143001
