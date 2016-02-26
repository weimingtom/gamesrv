--<<card 导表开始>>
local super = require "script.card.init"

ccard142003 = class("ccard142003",super,{
    sid = 142003,
    race = 4,
    name = "狂野怒火",
    type = 101,
    magic_immune = 0,
    assault = 0,
    sneer = 0,
    atkcnt = 0,
    shield = 0,
    warcry = 0,
    dieeffect = 0,
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
    atk = 0,
    hp = 0,
    crystalcost = 1,
    targettype = 32,
    desc = "在本回合内,使1个野兽获得+2攻击和免疫。",
})

function ccard142003:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard142003:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard142003:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

function ccard142003:onuse(pos,targetid,choice)
	local owner = self:getowner()
	local target = owner:gettaret(targetid)
	target:addbuff({
		srcid = self.id,
		sid = self.sid,
		addatk = 2,
		immune = 1,
		exceedround = owner.roundcnt + 1,
	})
end

return ccard142003
