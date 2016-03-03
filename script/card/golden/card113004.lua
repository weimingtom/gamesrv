--<<card 导表开始>>
local super = require "script.card.init"

ccard113004 = class("ccard113004",super,{
    sid = 113004,
    race = 1,
    name = "肯瑞托法师",
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
    magic_hurt = 0,
    recoverhp = 0,
    cure_to_hurt = 0,
    recoverhp_multi = 1,
    magic_hurt_multi = 1,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 4,
    hp = 3,
    crystalcost = 3,
    targettype = 23,
    halo = nil,
    desc = "战吼：在本回合中你使用的下一个奥秘的法力值消耗为0",
    effect = {
        onuse = {addbuff={setcrystalcost=0,lifecircle=1}},
        ondie = nil,
        onhurt = nil,
        onrecorverhp = nil,
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

function ccard113004:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard113004:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard113004:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

function ccard113004:onuse(pos,targetid,choice)
	local owner = self:getowner()
	for i,id in ipairs(owner.handcards) do
		local warcard = owner:gettarget(id)
		if is_secretcard(warcard.type) then
			local buff = self:newbuff(ccard113004.effect.onuse.addbuff)
			warcard:addbuff(buff)
		end
	end
end

function ccard113004:after_playcard(warcard,pos,targetid,choice)
	if self.inarea ~= "war" then
		return
	end
	local owner = self:getowner()
	if self.enterwar_roundcnt ~= owner.roundcnt then
		return
	end
	if owner:isenemy(warcard.id) then
		return
	end
	local isfirst_playcard = false
	for i,buff in ipairs(warcard.buffs) do
		if buff.srcid == self.id then
			isfirst_playcard = true
			break
		end
	end
	if isfirst_playcard then
		for i,id in ipairs(owner.handcards) do
			local handcard = owner:gettarget(id)
			if is_secretcard(handcard.type) then
				handcard:delbuffbysrcid(self.id)
			end
		end
	end
end

return ccard113004
