--<<card 导表开始>>
local super = require "script.card.init"

ccard163013 = class("ccard163013",super,{
    sid = 163013,
    race = 6,
    name = "鱼人招潮者",
    type = 203,
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
    atk = 1,
    maxhp = 2,
    crystalcost = 1,
    targettype = 0,
    halo = nil,
    desc = "每当有玩家召唤一个鱼人时,便获得+1攻击力。",
    effect = {
        onuse = nil,
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
        after_putinwar = {addbuff={addatk=1}},
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

function ccard163013:init(conf)
    super.init(self,conf)
--<<card 导表结束>>

end --导表生成

function ccard163013:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data)
    -- todo: load data
end

function ccard163013:save()
    local data = super.save(self)
    -- todo: save data
    return data
end

function ccard163013:after_putinwar(warcard,pos,targetid,choice)
	if self.inarea ~= "war" then
		return
	end
	if self.id == warcard.id then
		return
	end
	if warcard.type ~= FOOTMAN.FISH then
		return
	end
	local buff = self:newbuff(ccard163013.effect.after_putinwar.addbuff)
	self:addbuff(buff)
end

return ccard163013
