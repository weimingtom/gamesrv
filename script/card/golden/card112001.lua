--<<card 导表开始>>
local super = require "script.card.init"

ccard112001 = class("ccard112001",super,{
    sid = 112001,
    race = 1,
    name = "寒冰屏障",
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
    cure_to_hurt = 0,
    recoverhp_multi = 1,
    magic_hurt_multi = 1,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 0,
    maxhp = 0,
    crystalcost = 3,
    targettype = 11,
    halo = nil,
    desc = "奥秘：当你的英雄将要承受致命伤害时,防止这些伤害,并使其在本回合免疫",
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
        before_hurt = {immune=1},
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
        before_putinwar = nil,
        after_putinwar = nil,
        before_removefromwar = nil,
        after_removefromwar = nil,
        before_addsecret = nil,
        after_addsecret = nil,
        before_delsecret = nil,
        after_delsecret = nil,
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

function ccard112001:init(conf)
    super.init(self,conf)
--<<card 导表结束>>

end --导表生成

function ccard112001:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard112001:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

function ccard112001:before_hurt(obj,hurtval,srcid)
	if self.inarea ~= "war" then
		return
	end
	local owner = self:getowner()
	if owner.hero.id ~= obj.id then
		return
	end
	if owner.hero.hp <= hurtval then
		local state = ccard112001.effect.before_hurt.immnue
		owner.hero:setstate("immune",state)
		return true,true
	end
end

return ccard112001
