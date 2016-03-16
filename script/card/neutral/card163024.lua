--<<card 导表开始>>
local super = require "script.card.init"

ccard163024 = class("ccard163024",super,{
    sid = 163024,
    race = 6,
    name = "阿古斯防御者",
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
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 2,
    maxhp = 3,
    crystalcost = 4,
    targettype = 0,
    halo = nil,
    desc = "战吼：使相邻的随从获得+1/+1和嘲讽。",
    effect = {
        onuse = {addbuff={addatk=1,addmaxhp=1,addhp=1,sneer=60}},
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

function ccard163024:init(conf)
    super.init(self,conf)
--<<card 导表结束>>

end --导表生成

function ccard163024:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data)
    -- todo: load data
end

function ccard163024:save()
    local data = super.save(self)
    -- todo: save data
    return data
end

function ccard163024:onuse(pos,targetid,choice)
	local owner = self:getowner()
	local pos = self.pos
	local buff = self:newbuff(ccard163024.effect.onuse.addbuff)
	local left_id = owner.warcards[pos-1]
	local right_id = owner.warcards[pos+1]
	if left_id then
		local left_target = owner:gettarget(left_id)
		left_target:addbuff(buff)
	end
	if right_id then
		local right_target = owner:gettarget(right_id)
		right_target:addbuff(buff)
	end
end

return ccard163024
