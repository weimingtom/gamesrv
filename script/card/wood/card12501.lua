--<<card 导表开始>>
local super = require "script.card.init"

ccard12501 = class("ccard12501",super,{
    sid = 12501,
    race = 2,
    name = "圣光的正义",
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
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 1,
    hp = 4,
    crystalcost = 1,
    targettype = 0,
    desc = "None",
})

function ccard12501:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard12501:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard12501:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

-- warcard
require "script.war.aux"
require "script.war.warmgr"

function ccard12501:onuse(target)
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	local weapon = {
		id = self.id,
		sid = self.sid,
		atk = self.atk,
		usecnt = self.hp,
		atkcnt = self.atkcnt,
	}
	warobj.hero:equipweapon(weapon)
end

return ccard12501
