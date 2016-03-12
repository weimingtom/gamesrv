--<<card 导表开始>>
local super = require "script.card.init"

ccard163009 = class("ccard163009",super,{
    sid = 163009,
    race = 6,
    name = "狂奔科多兽",
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
    atk = 3,
    maxhp = 5,
    crystalcost = 5,
    targettype = 2,
    halo = nil,
    desc = "战吼：随机消灭一个攻击力小于或等于2的敌方随从。",
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

function ccard163009:init(conf)
    super.init(self,conf)
--<<card 导表结束>>

end --导表生成

function ccard163009:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard163009:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

function ccard163009:onuse(pos,targetid,choice)
	local owner = self:getowner()
	local ids = {}
	for i,id in ipairs(owner.enemy.warcards) do
		local footman = owner:gettarget(id)
		if footman.atk <= 2 then
			table.insert(ids,id)
		end
	end
	if not next(ids) then
		return
	end
	local id = randlist(ids)
	local footman = owner:gettarget(id)
	footman:die()
end

return ccard163009
