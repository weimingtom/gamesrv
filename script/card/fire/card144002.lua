--<<card 导表开始>>
local super = require "script.card.init"

ccard144002 = class("ccard144002",super,{
    sid = 144002,
    race = 4,
    name = "狙击",
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
    cure_to_hurt = 0,
    recoverhp_multi = 1,
    magic_hurt_multi = 1,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 0,
    maxhp = 0,
    crystalcost = 2,
    targettype = 0,
    halo = nil,
    desc = "奥秘：当对手打出1个随从时,对该随从造成4点伤害。",
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
        before_atttack = nil,
        after_attack = nil,
        before_playcard = nil,
        after_playcard = nil,
        before_putinwar = nil,
        after_putinwar = {costhp=4},
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

function ccard144002:init(conf)
    super.init(self,conf)
--<<card 导表结束>>

end --导表生成

function ccard144002:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard144002:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

function ccard144002:after_putinwar(footman,pos,reason)
	if reason ~= "playcard" then
		return
	end
	if self.inarea ~= "war" then
		return
	end
	local owner = self:getowner()
	if not owner:isenmey(footman.id) then
		return
	end
	local costhp = ccard144002.effect.after_putinwar.costhp
	footman:addhp(-costhp,self.id)
end

return ccard144002
