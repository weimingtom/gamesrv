--<<card 导表开始>>
local super = require "script.card.init"

ccard162004 = class("ccard162004",super,{
    sid = 162004,
    race = 6,
    name = "山岭巨人",
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
    atk = 8,
    maxhp = 8,
    crystalcost = 12,
    targettype = 0,
    halo = nil,
    desc = "你每有一张其他手牌,该牌的法力值消耗便减少（1）点。",
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

function ccard162004:init(conf)
    super.init(self,conf)
--<<card 导表结束>>

end --导表生成

function ccard162004:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data)
    -- todo: load data
end

function ccard162004:save()
    local data = super.save(self)
    -- todo: save data
    return data
end

function ccard162004:recompute()
	if self.addcrystalcost_buffid then
		self:delbuff(self.addcrystalcost_buffid)
		self.addcrystalcost_buffid = nil
	end
	local owner = self:getowner()
	local num = 0
	for i,id in ipairs(owner.handcards) do
		if id ~= self.id then
			num = num + 1
		end
	end
	if num == 0 then
		return
	end
	local buff = self:newbuff({
		addcrystalcost = -num
	})
	self.addcrystalcost_buffid = self:addbuff(buff)
end


function ccard162004:onputinhand()
	ccard162004.recompute(self)
end

function ccard162004:after_putinhand(handcard)
	if self.inarea ~= "hand" then
		return
	end
	ccard162004.recompute(self)
end

function ccard162004:after_removefromhand(handcard)
	if self.inarea ~= "hand" then
		return
	end
	ccard162004.recompute(self)
end

return ccard162004
