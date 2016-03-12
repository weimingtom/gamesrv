--<<card 导表开始>>
local super = require "script.card.init"

ccard145008 = class("ccard145008",super,{
    sid = 145008,
    race = 4,
    name = "杀戮命令",
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
    crystalcost = 3,
    targettype = 33,
    halo = nil,
    desc = "造成3点伤害。如果你有野兽,那么造成5点伤害取而代之。",
    effect = {
        onuse = {maigc_hurt=3,magic_hurt2=5},
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

function ccard145008:init(conf)
    super.init(self,conf)
--<<card 导表结束>>

end --导表生成

function ccard145008:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard145008:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

function ccard145008:onuse(pos,targetid,choice)
	local owner = getowner()
	local target = owner:gettarget(targetid)
	local hasanimal = false
	for i,id in ipairs(owner.warcards) do
		local warcard = owner:gettarget(id)
		if warcard.type == FOOTMAN.ANIMAL then
			hasanimal = true
			break
		end
	end
	local magic_hurt
	if hasanimal then
		magic_hurt = ccard145008.onuse.magic_hurt2
	else
		magic_hurt = ccard145008.onse.magic_hurt
	end
	magic_hurt = self:get_magic_hurt(magic_hurt)
	target:addhp(-magic_hurt,self.id)
end

return ccard145008
