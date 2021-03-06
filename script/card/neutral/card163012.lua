--<<card 导表开始>>
local super = require "script.card.init"

ccard163012 = class("ccard163012",super,{
    sid = 163012,
    race = 6,
    name = "小个子召唤师",
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
    atk = 2,
    maxhp = 2,
    crystalcost = 2,
    targettype = 0,
    halo = nil,
    desc = "你每个回合使用的第一张随从牌的法力值消耗减少（1）点。",
    effect = {
        onuse = nil,
        ondie = nil,
        onhurt = nil,
        onrecoverhp = nil,
        onbeginround = {addbuff={addcrystalcost=-1}},
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

function ccard163012:init(conf)
    super.init(self,conf)
--<<card 导表结束>>

end --导表生成

function ccard163012:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data)
    -- todo: load data
end

function ccard163012:save()
    local data = super.save(self)
    -- todo: save data
    return data
end

function ccard163012:onbeginround()
	if self.inarea ~= "war" then
		return
	end
	local owner = self:getowner()
	local buff = self:newbuff(ccard163012.effect.onbeginround.addbuff)
	local id_buffid = {}
	for i,id in ipairs(owner.handcards) do
		local handcard = owner:gettarget(id)
		if is_footman(handcard.type) then
			local buffid = handcard:addbuff(buff)
			id_buffid[id] = buffid
		end
	end
	for id,buffid in pairs(id_buffid) do
		local handcard = owner:gettarget(id)
		local effect = self:neweffect({
			name = "before_playcard",
			callback = function (self,warcard,pos,targetid,choice)
				for id2,buffid2 in pairs(id_buffid) do
					local handcard = owner:gettarget(id2)
					if handcard then
						handcard:delbuff(buffid2)
					end
				end
			end,
		})
		handcard:addeffect(effect)
	end
end

return ccard163012
