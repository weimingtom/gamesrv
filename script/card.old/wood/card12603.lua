--<<card 导表开始>>
local super = require "script.card.init"

ccard12603 = class("ccard12603",super,{
    sid = 12603,
    race = 2,
    name = "灰烬使者",
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
    type = 301,
    magic_hurt = 0,
    recoverhp = 0,
    max_amount = 0,
    composechip = 0,
    decomposechip = 0,
    atk = 5,
    hp = 3,
    crystalcost = 5,
    targettype = 0,
    desc = "None",
})

function ccard12603:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard12603:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard12603:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

-- warcard
require "script.war.aux"
require "script.war.warmgr"
function ccard12603:onuse(target)
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	local weapon = {
		id = self.id,
		sid = self.sid,
		atk = 5,
		usecnt = 3,
		atkcnt = self.atkcnt,
	}
	warobj.hero:equipweapon(weapon)
end

return ccard12603
