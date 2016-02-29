--<<card 导表开始>>
local super = require "script.card.init"

ccard142001 = class("ccard142001",super,{
    sid = 142001,
    race = 4,
    name = "毒蛇陷阱",
    type = 102,
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
    crystalcost = 2,
    targettype = 0,
    desc = "奥秘：当你的1个随从遭到攻击时,召唤3条1/1毒蛇。",
    effect = {
        onuse = nil,
        ondie = nil,
        onhurt = nil,
        onrecorverhp = nil,
        onbeginround = nil,
        onendround = nil,
        before_die = nil,
        after_die = nil,
        before_hurt = nil,
        after_hurt = nil,
        before_recoverhp = nil,
        after_recoverhp = nil,
        before_beginround = nil,
        after_beginround = nil,
        before_endround = nil,
        after_endround = nil,
        before_atttack = nil,
        after_attack = nil,
        before_playcard = nil,
        after_playcard = nil,
    },
}

function ccard142001:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard142001:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard142001:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

function ccard142001:before_attack(attacker,defenser)
	local owner = self:getowner()
	if owner:isenemy(defenser.id) then
		return
	end
	if defenser.id ~= owner.id then
		return
	end
	assert(defenser.inarea == "war")
	assert(is_footman(defenser.type))
	owner:delsecret(self.id,"trigger")
	local sid = is_goldcard(self.sid) and 24006 or 14006
	for i=1,3 do
		local warcard = owner:newwarcard(sid)
		owner:putinwar(warcard)
	end
end

return ccard142001
