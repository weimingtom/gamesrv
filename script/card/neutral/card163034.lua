--<<card 导表开始>>
local super = require "script.card.init"

ccard163034 = class("ccard163034",super,{
    sid = 163034,
    race = 6,
    name = "憎恶",
    type = 201,
    magic_immune = 0,
    assault = 0,
    sneer = 1,
    atkcnt = 1,
    shield = 0,
    warcry = 0,
    dieeffect = 1,
    sneak = 0,
    magic_hurt_adden = 0,
    cure_to_hurt = 0,
    recoverhp_multi = 1,
    magic_hurt_multi = 1,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 4,
    maxhp = 4,
    crystalcost = 5,
    targettype = 0,
    halo = nil,
    desc = "嘲讽,亡语：对所有角色造成2点伤害。",
    effect = {
        onuse = nil,
        ondie = {costhp=2},
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

function ccard163034:init(conf)
    super.init(self,conf)
--<<card 导表结束>>

end --导表生成

function ccard163034:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data)
    -- todo: load data
end

function ccard163034:save()
    local data = super.save(self)
    -- todo: save data
    return data
end

function ccard163034:ondie()
	local owner = self:getowner()
	local costhp = ccard163034.effect.ondie.costhp
	local ids = deepcopy(owner.warcards)
	local ids2 = deepcopy(owner.enemy.warcards)
	for i,id in ipairs(ids) do
		local footman = owner:gettarget(id)
		footman:addhp(-costhp,self.id)
	end
	for i,id in ipairs(ids2) do
		local footman = owner:gettarget(id)
		footman:addhp(-costhp,self.id)
	end
end

return ccard163034
