--<<card 导表开始>>
local super = require "script.card.water.card131001"

ccard231001 = class("ccard231001",super,{
    sid = 231001,
    race = 3,
    name = "先知维纶",
    type = 201,
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
    recoverhp_multi = 2,
    magic_hurt_multi = 2,
    max_amount = 1,
    composechip = 100,
    decomposechip = 10,
    atk = 7,
    maxhp = 7,
    crystalcost = 7,
    targettype = 0,
    halo = nil,
    desc = "使你的法术牌和英雄技能的伤害和治疗效果翻倍。",
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

function ccard231001:init(conf)
    super.init(self,conf)
--<<card 导表结束>>

end --导表生成

function ccard231001:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard231001:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard231001
