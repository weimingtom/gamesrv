--<<card 导表开始>>
local super = require "script.card.init"

ccard114004 = class("ccard114004",super,{
    sid = 114004,
    race = 1,
    name = "法力浮龙",
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
    recoverhp_multi = 1,
    magic_hurt_multi = 1,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 1,
    maxhp = 3,
    crystalcost = 1,
    targettype = 0,
    halo = nil,
    desc = "每当你施放一个法术时,便获得+1攻击力",
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
        after_playcard = {addbuff={addatk=1}},
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

function ccard114004:init(conf)
    super.init(self,conf)
--<<card 导表结束>>

end --导表生成

function ccard114004:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard114004:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

function ccard114004:after_playcard(warcard,pos,targetid,choice)
	if self.inarea ~= "war" then
		return
	end
	if not is_magiccard(warcard.id) then
		return
	end
	local owner = self:getowner()
	if owner:isenemy(warcard) then
		return
	end
	local buff = self:newbuff(ccard114004.effect.after_playcard.addbuff)
	self:addbuff(buff)
end

return ccard114004
