--<<card 导表开始>>
local super = require "script.card.init"

ccard161009 = class("ccard161009",super,{
    sid = 161009,
    race = 6,
    name = "老瞎眼",
    type = 203,
    magic_immune = 0,
    assault = 1,
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
    max_amount = 1,
    composechip = 100,
    decomposechip = 10,
    atk = 2,
    maxhp = 4,
    crystalcost = 4,
    targettype = 0,
    halo = nil,
    desc = "冲锋,在战场上每有一个其他鱼人便获得+1攻击力。",
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

function ccard161009:init(conf)
    super.init(self,conf)
--<<card 导表结束>>

end --导表生成

function ccard161009:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data)
    -- todo: load data
end

function ccard161009:save()
    local data = super.save(self)
    -- todo: save data
    return data
end

function ccard161009:recompute()
	local owner = self:getowner()
	if self.fish_buffid then
		self:delbuff(self.fish_buffid)
		self.fish_buffid = nil
	end
	local num = 0
	for i,id in ipairs(owner.warcards) do
		if id ~= self.id then
			local footman = owner:gettarget(id)
			if footman.type == FOOTMAN.FISH then
				num = num + 1
			end
		end
	end
	for i,id in ipairs(owner.enemy.warcards) do
		local footman = owner:gettarget(id)
		if footman.type == FOOTMAN.FISH then
			num = num + 1
		end
	end
	local buff = self:newbuff({
		addatk = num,
	})
	self.fish_buffid = self:addbuff(buff)
end

function ccard161009:onputinwar(pos,reason)
	ccard161009.recompute(self)
end

function ccard161009:after_putinwar(footman,pos,reason)
	if footman.type ~= FOOTMAN.FISH then
		return
	end
	ccard161009.recompute(self)
end

function ccard161009:after_removefromwar(footman)
	if footman.type ~= FOOTMAN.FISH then
		return
	end
	ccard161009.recompute(self)
end

return ccard161009
