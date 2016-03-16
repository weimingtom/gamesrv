--<<card 导表开始>>
local super = require "script.card.init"

ccard111001 = class("ccard111001",super,{
    sid = 111001,
    race = 1,
    name = "大法师安东尼达斯",
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
    max_amount = 1,
    composechip = 100,
    decomposechip = 10,
    atk = 5,
    maxhp = 7,
    crystalcost = 7,
    targettype = 0,
    halo = nil,
    desc = "每当你施放一个法术时,将一张‘火球术’置入你的手牌",
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
        before_attack = nil,
        after_attack = nil,
        before_playcard = nil,
        after_playcard = {putinhand={sid=115002,num=1}},
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

function ccard111001:init(conf)
    super.init(self,conf)
--<<card 导表结束>>

end --导表生成

function ccard111001:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data)
    -- todo: load data
end

function ccard111001:save()
    local data = super.save(self)
    -- todo: save data
    return data
end

function ccard111001:after_playcard(warcard,pos,targetid,choice)
	if self.inarea ~= "war" then
		return
	end
	if not is_magiccard(warcard.type) then
		return
	end
	local owner = self:getowner()
	local sid = ccard111001.effect.after_playcard.putinhand.sid
	local num = ccard111001.effect.after_playcard.putinhand.num
	for i=1,num do
		local warcard = owner:newwarcard(sid)
		owner:putinhand(warcard.id)
	end
end

return ccard111001
