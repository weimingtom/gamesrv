--<<card 导表开始>>
local super = require "script.card.init"

ccard161008 = class("ccard161008",super,{
    sid = 161008,
    race = 6,
    name = "奥妮克希亚",
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
    cure_to_hurt = 0,
    recoverhp_multi = 1,
    magic_hurt_multi = 1,
    max_amount = 1,
    composechip = 100,
    decomposechip = 10,
    atk = 8,
    maxhp = 8,
    crystalcost = 9,
    targettype = 0,
    halo = nil,
    desc = "战吼：召唤数个1/1的雏龙,直到你的随从数量达到上限。",
    effect = {
        onuse = {addfootman={sid=166019}},
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

function ccard161008:init(conf)
    super.init(self,conf)
--<<card 导表结束>>

end --导表生成

function ccard161008:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data)
    -- todo: load data
end

function ccard161008:save()
    local data = super.save(self)
    -- todo: save data
    return data
end

function ccard161008:onuse(pos,targetid,choice)
	local owner = self:getowner()
	local sid = ccard161008.effect.onuse.addfootman.sid
	sid = togoldsidif(sid,is_goldcard(self.sid))
	local num = owner:getfreespace("warcard")
	local leftnum = num / 2
	for i=1,leftnum do
		local warcard = owner:newwarcard(sid)	
		owner:putinwar(warcard,self.pos)
	end
	for i=1,num-leftnum do
		local warcard = owner:newwarcard(sid)
		owner:putinwar(warcard,self.pos+1)
	end

end

return ccard161008
