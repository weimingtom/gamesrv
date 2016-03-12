--<<card 导表开始>>
local super = require "script.card.init"

ccard166025 = class("ccard166025",super,{
    sid = 166025,
    race = 6,
    name = "壮胆机器人3000型",
    type = 206,
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
    max_amount = 0,
    composechip = 0,
    decomposechip = 0,
    atk = 0,
    maxhp = 4,
    crystalcost = 1,
    targettype = 0,
    halo = nil,
    desc = "在你回合的结束阶段,使随机一名仆从获得+1/+1。",
    effect = {
        onuse = nil,
        ondie = nil,
        onhurt = nil,
        onrecoverhp = nil,
        onbeginround = nil,
        onendround = {addbuff={addatk=1,addmaxhp=1,addhp=1}},
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

function ccard166025:init(conf)
    super.init(self,conf)
--<<card 导表结束>>

end --导表生成

function ccard166025:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard166025:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

function ccard166025:onendround()
	local owner = self:getowner()
	local ids = deepcopy(owner.warcards)
	table.extend(ids,owner.enemy.warcards)
	if table.isempty(ids) then
		return
	end
	local id = randlist(ids)
	local footman = owner:gettarget(id)
	local buff = self:newbuff(ccard166025.effect.onendround.addbuff)
	footman:addbuff(buff)
end

return ccard166025
