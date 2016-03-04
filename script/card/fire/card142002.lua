--<<card 导表开始>>
local super = require "script.card.init"

ccard142002 = class("ccard142002",super,{
    sid = 142002,
    race = 4,
    name = "角斗士",
    type = 301,
    magic_immune = 0,
    assault = 0,
    sneer = 0,
    atkcnt = 1,
    shield = 0,
    warcry = 0,
    dieeffect = 0,
    sneak = 0,
    magic_hurt_adden = 0,
    cure_to_hurt = 0,
    recoverhp_multi = 1,
    magic_hurt_multi = 1,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 5,
    maxhp = 2,
    crystalcost = 7,
    targettype = 0,
    halo = nil,
    desc = "你的英雄在攻击时具有免疫。",
    effect = {
        onuse = nil,
        ondie = nil,
        onhurt = nil,
        onrecorverhp = nil,
        onbeginround = nil,
        onendround = nil,
        ondelsecret = nil,
        onputinwar = nil,
        onremovefromwar = nil,
        onaddweapon = nil,
        onputinhand = nil,
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
        before_atttack = {immune=1},
        after_attack = {immune=0},
        before_playcard = nil,
        after_playcard = nil,
        before_putinwar = nil,
        after_putinwar = nil,
        before_removefromwar = nil,
        after_removefromwar = nil,
        before_addsecret = nil,
        after_addsecret = nil,
        before_addweapon = nil,
        after_addweapon = nil,
        before_delweapon = nil,
        after_delweapon = nil,
        before_putinhand = nil,
        after_putinhand = nil,
        before_removefromhand = nil,
        after_removefromhand = nil,
    },
})

function ccard142002:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard142002:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard142002:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

function ccard142002:before_attack(attacker,defenser)
	if self.inarea ~= "war" then
		return true,true
	end
	local owner = self:getowner()
	if owner.hero.id == attacker.id then
		local state = ccard142002.effect.before_attack.immune
		owner.hero:setstate("immune",state)
	end
	return true,true
end

function ccard142002:after_attack(attacker,defenser)
	if self.inarea ~= "war" then
		return
	end
	local owner = self:getowner()
	if owner.hero.id == attacker.id then
		local state = ccard142002.effect.after_attack.immune
		owner.hero:setstate("immune",state)
	end
	return
end

return ccard142002
