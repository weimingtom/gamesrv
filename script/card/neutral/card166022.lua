--<<card 导表开始>>
local super = require "script.card.init"

ccard166022 = class("ccard166022",super,{
    sid = 166022,
    race = 6,
    name = "修理机器人",
    type = 206,
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
    max_amount = 0,
    composechip = 0,
    decomposechip = 0,
    atk = 0,
    maxhp = 3,
    crystalcost = 1,
    targettype = 0,
    halo = nil,
    desc = "在你回合的结束阶段,为一个受到伤害的角色回复6点生命值。",
    effect = {
        onuse = nil,
        ondie = nil,
        onhurt = nil,
        onrecorverhp = nil,
        onbeginround = nil,
        onendround = {recoverhp=6},
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

function ccard166022:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard166022:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard166022:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

function ccard166022:onendround()
	local owner = self:getowner()
	local hurt_ids = {}
	if owner.hero.hp < owner.hero.maxhp then
		table.insert(hurt_ids,owner.hero.id)
	end
	if owner.enemy.hero.hp < owner.enemy.hero.maxhp then
		table.insert(hurt_ids,owner.enemy.hero.id)
	end
	for i,id in ipairs(owner.warcards) do
		local footman = owner:gettarget(id)
		if footman.hp < footman.maxhp then
			table.insert(hurt_ids,id)
		end
	end
	for i,id in ipairs(owner.enemy.warcards) do
		local footman = owner:gettarget(id)
		if footman.hp < footman.maxhp then
			table.insert(hurt_ids,id)
		end
	end
	if not next(hurt_ids) then
		return
	end
	local id = randlist(hurt_ids)
	local target = owner:gettarget(id)
	local recoverhp = ccard166022.effect.onendround.recoverhp
	recoverhp = self:getrecoverhp(recoverhp)
	target:addhp(recoverhp,self.id)
end

return ccard166022
