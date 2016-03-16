--<<card 导表开始>>
local super = require "script.card.init"

ccard134006 = class("ccard134006",super,{
    sid = 134006,
    race = 3,
    name = "思维窃取",
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
    targettype = 0,
    halo = nil,
    desc = "复制对手的牌库中的2张牌,并将其置入你的手牌。",
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

function ccard134006:init(conf)
    super.init(self,conf)
--<<card 导表结束>>

end --导表生成

function ccard134006:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data)
    -- todo: load data
end

function ccard134006:save()
    local data = super.save(self)
    -- todo: save data
    return data
end

function ccard134006:onuse(pos,targetid,choice)
	local owner = self:getowner()
	local ids = shuffle(owner.enemy.leftcards,false,2)
	for i,id in ipairs(ids) do
		local warcard = owner:gettarget(id)
		local clone_warcard = owner:clone(warcard)
		owner:putinhand(clone_warcard.id)
	end
end

return ccard134006
