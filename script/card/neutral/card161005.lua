--<<card 导表开始>>
local super = require "script.card.init"

ccard161005 = class("ccard161005",super,{
    sid = 161005,
    race = 6,
    name = "席尔瓦娜斯·风行者",
    type = 201,
    magic_immune = 0,
    assault = 0,
    sneer = 0,
    atkcnt = 1,
    shield = 0,
    warcry = 0,
    dieeffect = 1,
    sneak = 0,
    magic_hurt_adden = 0,
    cure_to_hurt = 0,
    recoverhp_multi = 1,
    magic_hurt_multi = 1,
    max_amount = 1,
    composechip = 100,
    decomposechip = 10,
    atk = 5,
    maxhp = 5,
    crystalcost = 6,
    targettype = 0,
    halo = nil,
    desc = "亡语：控制一个随机敌方随从。",
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

function ccard161005:init(conf)
    super.init(self,conf)
--<<card 导表结束>>

end --导表生成

function ccard161005:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data)
    -- todo: load data
end

function ccard161005:save()
    local data = super.save(self)
    -- todo: save data
    return data
end

function ccard161005:ondie()
	local owner = self:getowner()
	if not next(owner.enemy.warcards) then
		return
	end
	local id = randlist(owner.enemy.warcards)	
	local warcard = owner:gettarget(id)
	if warcard:getowner():removefromwar(warcard) then
		warcard:setowner(owner)
		owner:putinwar(warcard,self.pos)
	end
end


return ccard161005
