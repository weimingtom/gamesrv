--<<card 导表开始>>
local super = require "script.card.init"

ccard161011 = class("ccard161011",super,{
    sid = 161011,
    race = 6,
    name = "米尔豪斯·法力风暴",
    type = 201,
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
    max_amount = 1,
    composechip = 100,
    decomposechip = 10,
    atk = 4,
    maxhp = 4,
    crystalcost = 2,
    targettype = 0,
    halo = nil,
    desc = "战吼：下个回合敌方法术的法力值消耗为（0）点。",
    effect = {
        onuse = {addbuff={crystalcost=0,lifecircle=2}},
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
        after_putinhand = {addbuff={crystalcost=0,lifecircle=1}},
        before_removefromhand = nil,
        after_removefromhand = nil,
    },
})

function ccard161011:init(conf)
    super.init(self,conf)
--<<card 导表结束>>

end --导表生成

function ccard161011:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data)
    -- todo: load data
end

function ccard161011:save()
    local data = super.save(self)
    -- todo: save data
    return data
end

function ccard161011:onuse(pos,targetid,choice)
	local owner = self:getowner()
	local buff = self:newbuff(ccard161011.effect.onuse.addbuff)
	for i,id in ipairs(owner.enemy.handcards) do
		local handcard = owner:gettarget(id)
		handcard:addbuff(buff)
	end
end

function ccard161011:after_putinhand(warcard)
	if self.inarea ~= "war" then
		return
	end
	local owner = self:getowner()
	if not owner:isenemy(warcard) then
		return
	end
	local warcard_owner = warcard:getowner()
	if warcard_owner.type == "attacker" and warcard_owner.roundcnt ~= self.enterwar_roundcnt + 1 then
		return
	end
	if warcard_owner.type == "defenser" and warcard_owner.roundcnt ~= self.enterwar_roundcnt then
		return
	end
	-- 敌方下一回合“抽牌”
	local buff = self:newbuff(ccard161011.effect.after_putinhand.addbuff)
	warcard:addbuff(buff)
end

return ccard161011
