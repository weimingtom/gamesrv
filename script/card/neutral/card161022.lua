--<<card 导表开始>>
local super = require "script.card.init"

ccard161022 = class("ccard161022",super,{
    sid = 161022,
    race = 6,
    name = "凯恩·血蹄",
    type = 201,
    magic_immune = 0,
    assault = 0,
    sneer = 0,
    atkcnt = 1,
    shield = 0,
    warcry = 0,
    dieeffect = 1,
    sneak = 0,
    magic_hurt_adden = 0,
    cure_to_hurt = 0,
    recoverhp_multi = 1,
    magic_hurt_multi = 1,
    max_amount = 1,
    composechip = 100,
    decomposechip = 10,
    atk = 4,
    maxhp = 5,
    crystalcost = 6,
    targettype = 0,
    halo = nil,
    desc = "亡语：召唤一个4/5的贝恩·血蹄。",
    effect = {
        onuse = nil,
        ondie = {addfootman={sid=166026,num=1}},
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

function ccard161022:init(conf)
    super.init(self,conf)
--<<card 导表结束>>

end --导表生成

function ccard161022:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data)
    -- todo: load data
end

function ccard161022:save()
    local data = super.save(self)
    -- todo: save data
    return data
end

function ccard161022:ondie()
	local owner = self:getowner()
	local sid = ccard161022.effect.ondie.addfootman.sid
	local num = ccard161022.effect.ondie.addfootman.num
	sid = togoldsidif(sid,is_goldcard(self.sid))
	num = math.min(num,owner:getfreespace("warcard"))
end

return ccard161022
