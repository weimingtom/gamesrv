--<<card 导表开始>>
local super = require "script.card.init"

ccard166023 = class("ccard166023",super,{
    sid = 166023,
    race = 6,
    name = "侏儒变鸡器",
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
    maxhp = 3,
    crystalcost = 1,
    targettype = 0,
    halo = nil,
    desc = "在你回合的开始阶段,将随机一名随从变成一只1/1的小鸡。",
    effect = {
        onuse = nil,
        ondie = nil,
        onhurt = nil,
        onrecoverhp = nil,
        onbeginround = {addfootman={sid=163030}},
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

function ccard166023:init(conf)
    super.init(self,conf)
--<<card 导表结束>>

end --导表生成

function ccard166023:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data)
    -- todo: load data
end

function ccard166023:save()
    local data = super.save(self)
    -- todo: save data
    return data
end

function ccard166023:onbeginround()
	local owner = self:getowner()
	local ids = deepcopy(owner.enemy.warcards)
	for i,id in ipairs(owner.warcards) do
		if self.id ~= id then
			table.insert(ids,id)
		end
	end
	if not next(ids) then
		return
	end
	local id = randlist(ids)
	local target = owner:gettarget(id)
	local target_owner = target:getowner()
	if target_owner:removefromwar(target) then
		local sid = ccard166023.effect.onbeginround.addfootman.sid
		sid = togoldsidif(sid,is_goldcard(self.sid))
		local footman = target_owner:newwarcard(sid)
		target_owner:putinwar(footman,target.pos)
	end
end

return ccard166023
