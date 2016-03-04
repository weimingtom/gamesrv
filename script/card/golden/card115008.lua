--<<card 导表开始>>
local super = require "script.card.init"

ccard115008 = class("ccard115008",super,{
    sid = 115008,
    race = 1,
    name = "寒冰箭",
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
    crystalcost = 2,
    targettype = 33,
    halo = nil,
    desc = "对一个角色造成3点伤害,并使其冻结",
    effect = {
        onuse = {magic_hurt=1,addbuff={freeze=1,lifecircle=2}},
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

function ccard115008:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard115008:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard115008:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

function ccard115008:onuse(pos,targetid,choice)
	local owner = self:getowner()
	local target = owner:gettarget(targetid)
	local magic_hurt = ccard115008.effect.onuse.magic_hurt
	magic_hurt = self:get_magic_hurt(magic_hurt)
	local buff = self:newbuff(ccard115008.effect.onuse.addbuff)
	if targetid == owner.hero.id or targetid == owner.enemy.hero.id then
		local lifecircle = buff.lifecircle or buff.freeze
		target:setstate("freeze",lifecircle)
	else
		target:addbuff(buff)
	end
	target:addhp(-magic_hurt,self.id)
end

return ccard115008
