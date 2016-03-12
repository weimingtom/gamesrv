--<<card 导表开始>>
local super = require "script.card.init"

ccard162006 = class("ccard162006",super,{
    sid = 162006,
    race = 6,
    name = "鱼人杀人蟹",
    type = 202,
    magic_immune = 0,
    assault = 0,
    sneer = 0,
    atkcnt = 1,
    shield = 0,
    warcry = 1,
    dieeffect = 0,
    sneak = 0,
    magic_hurt_adden = 0,
    cure_to_hurt = 0,
    recoverhp_multi = 1,
    magic_hurt_multi = 1,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 1,
    maxhp = 2,
    crystalcost = 1,
    targettype = 32,
    halo = nil,
    desc = "战吼：消灭一个鱼人,并获得+2/+2。",
    effect = {
        onuse = {addbuff={addatk=2,addmaxhp=2,addhp=2}},
        ondie = nil,
        onhurt = nil,
        onrecoverhp = nil,
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

function ccard162006:init(conf)
    super.init(self,conf)
--<<card 导表结束>>

end --导表生成

function ccard162006:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard162006:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

function ccard162006:onuse(pos,targetid,choice)
	local owner = self:getowner()
	local footman = owner:gettarget(targetid)
	if footman.type ~= FOOTMAN.FISH then
		return
	end
	footman:die()
	local buff = self:newbuff(ccard162006.effect.onuse.addbuff)
	self:addbuff(buff)
end

return ccard162006
