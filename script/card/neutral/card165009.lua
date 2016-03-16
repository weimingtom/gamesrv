--<<card 导表开始>>
local super = require "script.card.init"

ccard165009 = class("ccard165009",super,{
    sid = 165009,
    race = 6,
    name = "工程师学徒",
    type = 205,
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
    maxhp = 1,
    crystalcost = 2,
    targettype = 0,
    halo = nil,
    desc = "战吼：抽一张牌。",
    effect = {
        onuse = {pickcard={num=1}},
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
        before_attack = nil,
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

function ccard165009:init(conf)
    super.init(self,conf)
--<<card 导表结束>>

end --导表生成

function ccard165009:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data)
    -- todo: load data
end

function ccard165009:save()
    local data = super.save(self)
    -- todo: save data
    return data
end

function ccard165009:onuse(pos,targetid,choice)
	local owner = self:getowner()
	local num = ccard165009.effect.onuse.pickcard.num
	for i=1,num do
		owner:pickcard_and_putinhand()
	end
end

return ccard165009
