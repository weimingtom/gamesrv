--<<card 导表开始>>
local super = require "script.card.init"

ccard166008 = class("ccard166008",super,{
    sid = 166008,
    race = 6,
    name = "伊瑟拉的觉醒",
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
    max_amount = 0,
    composechip = 0,
    decomposechip = 0,
    atk = 0,
    maxhp = 0,
    crystalcost = 2,
    targettype = 0,
    halo = nil,
    desc = "对除了伊瑟拉以外的全部角色造成5点伤害",
    effect = {
        onuse = {magic_hurt=5},
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

function ccard166008:init(conf)
    super.init(self,conf)
--<<card 导表结束>>

end --导表生成

function ccard166008:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard166008:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

function ccard166008:onuse(pos,targetid,choice)
	local owner = self:getowner()
	local magic_hurt = ccard166008.effect.onuse.magic_hurt
	magic_hurt = self:get_magic_hurt(magic_hurt)
	local ids = deepcopy(owner.warcards)
	local ids2 = deepcopy(owner.enemy.warcards)
	for i,id in ipairs(ids2) do
		local footman = owner:gettarget(id)
		if footman.sid ~= 161001 and footman.sid ~= 261001 then
			footman:addhp(-magic_hurt,self.id)	
		end
	end
	for i,id in ipairs(ids) do
		local footman = owner:gettarget(id)
		if footman.sid ~= 161001 and footman.sid ~= 261001 then
			footman:addhp(-magic_hurt,self.id)
		end
	end
	owner.enemy.hero:addhp(-magic_hurt,self.id)
	owner.hero:addhp(-magic_hurt,self.id)
end

return ccard166008
