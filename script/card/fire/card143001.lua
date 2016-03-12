--<<card 导表开始>>
local super = require "script.card.init"

ccard143001 = class("ccard143001",super,{
    sid = 143001,
    race = 4,
    name = "长鬃草原狮",
    type = 202,
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
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 6,
    maxhp = 5,
    crystalcost = 6,
    targettype = 0,
    halo = nil,
    desc = "亡语：召唤2只2/2土狼。",
    effect = {
        onuse = nil,
        ondie = {addfootman={sid=146002,num=2}},
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

function ccard143001:init(conf)
    super.init(self,conf)
--<<card 导表结束>>

end --导表生成

function ccard143001:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data)
    -- todo: load data
end

function ccard143001:save()
    local data = super.save(self)
    -- todo: save data
    return data
end

function ccard143001:ondie()
	local owner = self:getowner()
	local num = ccard143001.effect.ondie.addfootman.num
	num = math.min(num,owner:getfreepos("warcard"))
	local sid = ccard143001.effect.ondie.addfootman.sid
	sid = togoldsidif(sid,is_goldcard(self.sid))
	for i=1,num do
		local warcard = owner:newwarcard(sid)
		owner:putinwar(warcard,self.pos)
	end
	return
end

return ccard143001
