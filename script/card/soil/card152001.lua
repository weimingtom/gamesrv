--<<card 导表开始>>
local super = require "script.card.init"

ccard152001 = class("ccard152001",super,{
    sid = 152001,
    race = 5,
    name = "自然之力",
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
    crystalcost = 6,
    targettype = 0,
    halo = nil,
    desc = "召唤3个2/2并具有冲锋的树人,在回合结束时,消灭这些树人。",
    effect = {
        onuse = {addfootman={sid=156021,num=3}},
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

function ccard152001:init(conf)
    super.init(self,conf)
--<<card 导表结束>>

end --导表生成

function ccard152001:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard152001:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

function ccard152001:onuse(pos,targetid,choice)
	local owner = self:getowner()
	local sid = ccard152001.effect.onuse.sid
	local num = ccard152001.effect.onuse.num
	num = math.min(num,owner:getfreespace("warcard"))
	for i=1,num do
		local warcard = owner:newwarcard(sid)
		owner:putinwar(warcard)
	end
end

return ccard152001
