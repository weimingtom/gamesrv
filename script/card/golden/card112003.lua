--<<card 导表开始>>
local super = require "script.card.init"

ccard112003 = class("ccard112003",super,{
    sid = 112003,
    race = 1,
    name = "扰咒术",
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
    crystalcost = 3,
    targettype = 0,
    halo = nil,
    desc = "奥秘：当一个敌方法术以一个随从作为目标时,召唤一个1/3的随从并使其成为新目标",
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
        before_playcard = {addfootman={sid=116003}},
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

function ccard112003:init(conf)
    super.init(self,conf)
--<<card 导表结束>>

end --导表生成

function ccard112003:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data)
    -- todo: load data
end

function ccard112003:save()
    local data = super.save(self)
    -- todo: save data
    return data
end

function ccard112003:before_playcard(warcard,pos,targetid,choice)
	if self.inarea ~= "war" then
		return
	end
	if not is_magiccard(warcard.type) then
		return
	end
	local owner = self:getowner()
	if not owner:isenemy(warcard) then
		return
	end
	if not targetid then
		return
	end
	local target = owner:gettarget(targetid)
	if owner:ishero(target) then
		return
	end
	if owner:getfreespace("warcard") <= 0 then
		return
	end
	owner:delsecret(self.id,"trigger")
	local sid = ccard112003.effect.before_playcard.addfootman.sid
	local footman = owner:newwarcard(sid)
	owner:putinwar(footman)
	warcard:getowner():__playcard(warcard,pos,footman.id,choice)	
	return true,true
end

return ccard112003
