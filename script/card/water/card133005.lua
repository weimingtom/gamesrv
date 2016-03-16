--<<card 导表开始>>
local super = require "script.card.init"

ccard133005 = class("ccard133005",super,{
    sid = 133005,
    race = 3,
    name = "光明之泉",
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
    cure_to_hurt = 1,
    recoverhp_multi = 1,
    magic_hurt_multi = 1,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 0,
    maxhp = 5,
    crystalcost = 2,
    targettype = 0,
    halo = nil,
    desc = "在你的回合开始时,随机为一个受到伤害的友方角色恢复3点生命值。",
    effect = {
        onuse = nil,
        ondie = nil,
        onhurt = nil,
        onrecoverhp = nil,
        onbeginround = {recoverhp=3},
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

function ccard133005:init(conf)
    super.init(self,conf)
--<<card 导表结束>>

end --导表生成

function ccard133005:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data)
    -- todo: load data
end

function ccard133005:save()
    local data = super.save(self)
    -- todo: save data
    return data
end

function ccard133005:onbeginround()
	local owner = self:getowner()
	local hitids = {}
	for i,id in ipairs(owner.warcards) do
		local warcard = owner:gettarget(id)
		if warcard.hp < warcard.maxhp then
			table.insert(hitids,id)
		end
	end
	if owner.hero.hp < owner.hero.maxhp then
		table.insert(hitids,owner.hero.id)
	end
	if table.isempty(hitids) then
		return
	end
	local id = randlist(hitids)
	local target = owner:gettarget(id)
	local recoverhp = ccard133005.effect.onbeginround.recoverhp
	recoverhp = self:getrecoverhp(recoverhp)
	target:addhp(recoverhp,self.id)
end

return ccard133005
