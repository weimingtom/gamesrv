--<<card 导表开始>>
local super = require "script.card.init"

ccard115003 = class("ccard115003",super,{
    sid = 115003,
    race = 1,
    name = "奥术飞弹",
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
    desc = "造成3点伤害,随机分配给敌方角色",
    effect = {
        onuse = {magic_hurt=3},
        ondie = nil,
        onhurt = nil,
        onrecorverhp = nil,
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

function ccard115003:init(conf)
    super.init(self,conf)
--<<card 导表结束>>

end --导表生成

function ccard115003:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard115003:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end


function ccard115003:onuse(pos,targetid,choice)
	local owner = self:getowner()
	local magic_hurt = ccard115003.effect.onuse.magic_hurt
	magic_hurt = self:get_magic_hurt(magic_hurt)
	local id_hp = {}
	for i,id in ipairs(owner.enemy.warcards) do
		local warcard = owner:gettarget(id)
		id_hp[id] = warcard.hp
	end
	id_hp[owner.enemy.hero.id] = owner.enemy.hero.hp
	local id_hurt = alloc_hurt(magic_hurt,id_hp)
	for id,hurt in pairs(id_hurt) do
		local target = owner:gettarget(id)
		target:addhp(-hurt,self.id)
	end
end

return ccard115003
