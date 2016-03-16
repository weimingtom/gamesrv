--<<card 导表开始>>
local super = require "script.card.init"

ccard164022 = class("ccard164022",super,{
    sid = 164022,
    race = 6,
    name = "疯狂投弹者",
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
    maxhp = 2,
    crystalcost = 2,
    targettype = 0,
    halo = nil,
    desc = "战吼：造成3点伤害,随机由所有其他角色分摊。",
    effect = {
        onuse = {costhp=3},
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

function ccard164022:init(conf)
    super.init(self,conf)
--<<card 导表结束>>

end --导表生成

function ccard164022:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data)
    -- todo: load data
end

function ccard164022:save()
    local data = super.save(self)
    -- todo: save data
    return data
end

function ccard164022:onuse(pos,targetid,choice)
	local owner = self:getowner()
	local costhp = ccard164022.effect.onuse.costhp
	local id_hp = {}
	id_hp[owner.hero.id] = owner.hero.hp
	for i,id in ipairs(owner.warcards) do
		if self.id ~= id then
			local warcard = owner:gettarget(id)
			id_hp[id] = warcard.hp
		end
	end
	id_hp[owner.enemy.hero.id] = owner.enemy.hero.hp
	for i,id in ipairs(owner.enemy.warcards) do
		local warcard = owner:gettarget(id)
		id_hp[id] = warcard.hp
	end
	local id_hurt = alloc_hurt(costhp,id_hp)	
	for id,hurt in pairs(id_hurt) do
		local target = owner:gettarget(id)
		target:addhp(-hurt,self.id)
	end
end

return ccard164022
