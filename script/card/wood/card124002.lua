--<<card 导表开始>>
local super = require "script.card.init"

ccard124002 = class("ccard124002",super,{
    sid = 124002,
    race = 2,
    name = "救赎",
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
    crystalcost = 1,
    targettype = 0,
    halo = nil,
    desc = "奥秘：当一个你的随从死亡时,使其回到战场,并具有1点生命值。",
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

function ccard124002:init(conf)
    super.init(self,conf)
--<<card 导表结束>>

end --导表生成

function ccard124002:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data)
    -- todo: load data
end

function ccard124002:save()
    local data = super.save(self)
    -- todo: save data
    return data
end

function ccard124002:after_die(footman)
	if self.inarea ~= "war" then
		return
	end
	local owner = self:getowner()
	if owner:isenemy(footman) then
		return
	end
	-- 对方回合死亡时才触发
	if owner.state == "beginround" then
		return
	end
	footman:set({hp=1})
	owner:putinwar(footman,footman.pos)
end

return ccard124002
