--<<card 导表开始>>
local super = require "script.card.init"

ccard161006 = class("ccard161006",super,{
    sid = 161006,
    race = 6,
    name = "精英牛头人酋长",
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
    atk = 5,
    maxhp = 5,
    crystalcost = 5,
    targettype = 0,
    halo = nil,
    desc = "战吼：让两位玩家都具有摇滚的能力！（双方各获得一张强力和弦牌）",
    effect = {
        onuse = nil,
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

function ccard161006:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard161006:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard161006:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

function ccard161006:onuse(pos,targetid,choice)
	local owner = self:getowner()
	local sid = randlist({166024})
	sid = togoldsidif(sid,is_goldcard(self.sid))
	local warcard = owner:newwarcard(sid)
	owner:putinhand(warcard.id)
	warcard = owner.enemy:newwarcard(sid)
	owner.enemy:putinhand(warcard.id)
end

return ccard161006
