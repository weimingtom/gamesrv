--<<card 导表开始>>
local super = require "script.card.init"

ccard114006 = class("ccard114006",super,{
    sid = 114006,
    race = 1,
    name = "巫师学徒",
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
    cure_to_hurt = 0,
    recoverhp_multi = 1,
    magic_hurt_multi = 1,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 3,
    maxhp = 2,
    crystalcost = 2,
    targettype = 23,
    halo = {addcrystalcost=-1},
    desc = "你的法术的法力值消耗减少1点",
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

function ccard114006:init(conf)
    super.init(self,conf)
--<<card 导表结束>>

end --导表生成

function ccard114006:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard114006:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

function ccard114006:onputinwar(pos,reason)
	local owner = self:getowner()
	for i,id in ipairs(owner.handcards) do
		local handcard = owner:gettarget(id)
		if is_magiccard(handcard.type) then
			self:addhaloto(handcard)
		end
	end
end

function ccard114006:after_putinhand(handcard)
	if self.inarea ~= "war" then
		return
	end
	if not is_magiccard(handcard.type) then
		return
	end
	local owner = self:getowner()
	if owner:isenemy(handcard) then
		return
	end
	self:addhaloto(handcard)
end

return ccard114006
